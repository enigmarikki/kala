/*********************************************************************
 *  RSW GPU timelock solver BENCHMARK - 10K puzzles
 *********************************************************************/
#include <cuda.h>
#include <gmp.h>
#include <cuda_runtime.h>
#include "cgbn/cgbn.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <chrono>
#include <vector>
#include <string>

#include <wolfssl/options.h>
#include <wolfssl/wolfcrypt/aes.h>

/* ---------- helpers: CUDA / CGBN error macros ---------- */
#define CUDA_CHECK(call)                                                      \
  do {                                                                        \
    cudaError_t err = call;                                                   \
    if (err != cudaSuccess) {                                                 \
      fprintf(stderr,"CUDA error %s:%d : %s\n",__FILE__,__LINE__,             \
              cudaGetErrorString(err));                                       \
      exit(1);                                                                \
    }                                                                         \
  } while(0)

#define CGBN_CHECK(report)  cgbn_error_report_check(report)

/* ---------- parameters ---------- */
#define BITS 2048
#define TPI   32      /* threads‑per‑instance */
#define BATCH_SIZE 10000

/* ---------- CGBN typedefs ---------- */
typedef cgbn_context_t<TPI>         context_t;
typedef cgbn_env_t<context_t,BITS>  env_t;
typedef env_t::cgbn_t               bn_t;

/* ---------- GPU instance ---------- */
struct gpu_inst {
  cgbn_mem_t<BITS> a, n, C;
  uint32_t         T;
  uint8_t          key[32];   /* output */
};

/* ---------- kernel ---------- */
__global__ void rsw_kernel(cgbn_error_report_t *report,
                           gpu_inst *insts, int count) {

  int inst = (blockIdx.x * blockDim.x + threadIdx.x) / TPI;
  if (inst >= count) return;

  context_t ctx(cgbn_report_monitor, report, inst);
  env_t     env(ctx);

  bn_t a,n,C,res,k;
  cgbn_load(env,a,&insts[inst].a);
  cgbn_load(env,n,&insts[inst].n);
  cgbn_load(env,C,&insts[inst].C);

  /* Montgomery setup */
  uint32_t np0 = -cgbn_binary_inverse_ui32(env,cgbn_get_ui32(env,n));
  cgbn_bn2mont(env,res,a,n);

  /* 2^T sequential squarings */
  uint32_t T = insts[inst].T;
  for(uint32_t i=0;i<T;i++)
    cgbn_mont_sqr(env,res,res,n,np0);

  cgbn_mont2bn(env,res,res,n,np0);          /* back to normal space */

  /* k = (C - res) mod n */
  if(cgbn_compare(env,C,res)>=0)
    cgbn_sub(env,k,C,res);
  else {
    cgbn_add(env,k,C,n);
    cgbn_sub(env,k,k,res);
  }

  /* export 256‑bit key little‑endian */
  #pragma unroll
  for(int limb=0; limb<8; ++limb) {
    uint32_t w = cgbn_extract_bits_ui32(env,k, limb*32, 32);
    unsigned char *p = insts[inst].key + 4*limb;
    p[0]=w&0xFF; p[1]=(w>>8)&0xFF; p[2]=(w>>16)&0xFF; p[3]=(w>>24)&0xFF;
  }
}

/* ---------- helpers ---------- */
static std::vector<uint8_t> hex2vec(const char *s) {
  size_t L=strlen(s);  if(L%2){fprintf(stderr,"odd hex len\n");exit(1);}
  std::vector<uint8_t> v(L/2);
  for(size_t i=0;i<v.size();i++) sscanf(s+2*i,"%2hhx",&v[i]);
  return v;
}
static void hex2bytes(const char *s,uint8_t *out,size_t len){
  for(size_t i=0;i<len;i++) sscanf(s+2*i,"%2hhx",&out[i]);
}
static void mpz_set_hex(mpz_t z,const char* h){ if(mpz_set_str(z,h,16)) exit(1); }
static void mpz_to_cgbn(cgbn_mem_t<BITS>& dst,const mpz_t src){
  memset(&dst,0,sizeof(dst));
  size_t cnt; mpz_export(dst._limbs,&cnt,-1,4,0,0,src);
}

/* ---------- host AES-GCM decrypt ---------- */
static std::string aesgcm_decrypt_host(const uint8_t key[32],
                                       const uint8_t iv[12],
                                       const uint8_t tag[16],
                                       const std::vector<uint8_t>& ct)
{
    std::vector<uint8_t> pt(ct.size());
    Aes aes;
    
    int ret = wc_AesGcmSetKey(&aes, key, 32);
    if (ret != 0) {
        fprintf(stderr, "AesGcmSetKey failed: %d\n", ret);
        exit(1);
    }

    ret = wc_AesGcmDecrypt(&aes,
                           pt.data(),                 /* out */
                           ct.data(),  ct.size(),     /* in  */
                           iv, 12,
                           tag, 16,
                           nullptr, 0);               /* no AAD */

    if (ret != 0) {
        fprintf(stderr, "GCM auth fail %d\n", ret);
        exit(1);
    }
    return {reinterpret_cast<char*>(pt.data()), pt.size()};
}

/* ---------- main ---------- */
int main(int argc,char**argv){
  if(argc!=8){
    fprintf(stderr,"usage: %s n a C T iv ct tag (hex)\n",argv[0]); return 1;}

  mpz_t n,a,C; mpz_inits(n,a,C,nullptr);
  mpz_set_hex(n,argv[1]); mpz_set_hex(a,argv[2]); mpz_set_hex(C,argv[3]);
  uint32_t T=strtoul(argv[4],nullptr,10);

  /* parse crypto params */
  uint8_t iv[12], tag[16];
  hex2bytes(argv[5], iv, 12);
  hex2bytes(argv[7], tag, 16);
  std::vector<uint8_t> ct = hex2vec(argv[6]);

  /* prepare single puzzle instance */
  gpu_inst single{}; 
  mpz_to_cgbn(single.n,n); 
  mpz_to_cgbn(single.a,a); 
  mpz_to_cgbn(single.C,C); 
  single.T=T;

  /* allocate for 10K instances (all same puzzle) */
  gpu_inst *h_batch = new gpu_inst[BATCH_SIZE];
  for(int i = 0; i < BATCH_SIZE; i++) {
    h_batch[i] = single;  // copy same puzzle
  }

  gpu_inst *d_batch; 
  cgbn_error_report_t *report;
  
  CUDA_CHECK(cudaSetDevice(0));
  CUDA_CHECK(cudaMalloc(&d_batch, sizeof(gpu_inst) * BATCH_SIZE));
  CUDA_CHECK(cudaMemcpy(d_batch, h_batch, sizeof(gpu_inst) * BATCH_SIZE, cudaMemcpyHostToDevice));
  CUDA_CHECK(cgbn_error_report_alloc(&report));

  /* calculate grid dimensions */
  int threads = 128;
  int instances_per_block = threads / TPI;
  int blocks = (BATCH_SIZE + instances_per_block - 1) / instances_per_block;

  printf("Solving %d puzzles...\n", BATCH_SIZE);
  printf("Grid: %d blocks x %d threads\n", blocks, threads);
  printf("Instances per block: %d\n", instances_per_block);

  /* warm up */
  rsw_kernel<<<blocks,threads>>>(report, d_batch, BATCH_SIZE);
  CUDA_CHECK(cudaDeviceSynchronize());

  /* actual benchmark */
  auto t0 = std::chrono::high_resolution_clock::now();
  
  rsw_kernel<<<blocks,threads>>>(report, d_batch, BATCH_SIZE);
  CUDA_CHECK(cudaDeviceSynchronize());
  
  auto t1 = std::chrono::high_resolution_clock::now();
  
  CGBN_CHECK(report);

  /* get results back */
  CUDA_CHECK(cudaMemcpy(h_batch, d_batch, sizeof(gpu_inst) * BATCH_SIZE, cudaMemcpyDeviceToHost));

  /* timing stats */
  auto total_ms = std::chrono::duration_cast<std::chrono::milliseconds>(t1-t0).count();
  double ms_per_puzzle = (double)total_ms / BATCH_SIZE;
  double puzzles_per_sec = 1000.0 / ms_per_puzzle;

  printf("\n===== BENCHMARK RESULTS =====\n");
  printf("Total time: %ld ms\n", total_ms);
  printf("Time per puzzle: %.3f ms\n", ms_per_puzzle);
  printf("Throughput: %.1f puzzles/sec\n", puzzles_per_sec);
  printf("=============================\n");

  /* verify first and last results match */
  printf("\nFirst key:  ");
  for(int i=0; i<32; i++) printf("%02x", h_batch[0].key[i]);
  printf("\nLast key:   ");
  for(int i=0; i<32; i++) printf("%02x", h_batch[BATCH_SIZE-1].key[i]);
  printf("\n");

  /* decrypt the message */
  std::string plaintext = aesgcm_decrypt_host(h_batch[0].key, iv, tag, ct);
  printf("\nDecrypted message: \"%s\"\n", plaintext.c_str());

  /* cleanup */
  CUDA_CHECK(cudaFree(d_batch)); 
  CUDA_CHECK(cgbn_error_report_free(report));
  delete[] h_batch;
  mpz_clears(n,a,C,nullptr);
  
  return 0;
}