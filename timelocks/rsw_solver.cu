#include "rsw_solver.h"

#include <cuda.h>
#include <cuda_runtime.h>
#include <gmp.h>
#include "cgbn/cgbn.h"

#include <cstring>
#include <sstream>
#include <iomanip>

/* ---------- CUDA/CGBN error handling ---------- */
#define CUDA_CHECK(call)                                                      \
  do {                                                                        \
    cudaError_t err = call;                                                   \
    if (err != cudaSuccess) {                                                 \
      throw std::runtime_error(std::string("CUDA error: ") +                 \
                               cudaGetErrorString(err));                      \
    }                                                                         \
  } while(0)

#define CGBN_CHECK(report)  cgbn_error_report_check(report)

/* ---------- CGBN parameters ---------- */
#define BITS 2048
#define TPI   32      /* threads-per-instance */

/* ---------- CGBN typedefs ---------- */
typedef cgbn_context_t<TPI>         context_t;
typedef cgbn_env_t<context_t,BITS>  env_t;
typedef env_t::cgbn_t               bn_t;

namespace rsw {

/* ---------- GPU instance structure ---------- */
struct gpu_inst {
    cgbn_mem_t<BITS> a, n, C;
    uint32_t         T;
    uint8_t          key[32];   /* output */
};

/* ---------- RSW kernel ---------- */
__global__ void rsw_kernel(cgbn_error_report_t *report,
                          gpu_inst *insts, int count) {
    
    int inst = (blockIdx.x * blockDim.x + threadIdx.x) / TPI;
    if (inst >= count) return;
    
    context_t ctx(cgbn_report_monitor, report, inst);
    env_t     env(ctx);
    
    bn_t a, n, C, res, k;
    cgbn_load(env, a, &insts[inst].a);
    cgbn_load(env, n, &insts[inst].n);
    cgbn_load(env, C, &insts[inst].C);
    
    /* Montgomery setup */
    uint32_t np0 = -cgbn_binary_inverse_ui32(env, cgbn_get_ui32(env, n));
    cgbn_bn2mont(env, res, a, n);
    
    /* 2^T sequential squarings */
    uint32_t T = insts[inst].T;
    for(uint32_t i = 0; i < T; i++)
        cgbn_mont_sqr(env, res, res, n, np0);
    
    cgbn_mont2bn(env, res, res, n, np0);  /* back to normal space */
    
    /* k = (C - res) mod n */
    if(cgbn_compare(env, C, res) >= 0)
        cgbn_sub(env, k, C, res);
    else {
        cgbn_add(env, k, C, n);
        cgbn_sub(env, k, k, res);
    }
    
    /* export 256-bit key little-endian */
    #pragma unroll
    for(int limb = 0; limb < 8; ++limb) {
        uint32_t w = cgbn_extract_bits_ui32(env, k, limb*32, 32);
        unsigned char *p = insts[inst].key + 4*limb;
        p[0] = w & 0xFF; 
        p[1] = (w >> 8) & 0xFF; 
        p[2] = (w >> 16) & 0xFF; 
        p[3] = (w >> 24) & 0xFF;
    }
}

/* ---------- Helper functions ---------- */
static void mpz_to_cgbn(cgbn_mem_t<BITS>& dst, const mpz_t src) {
    memset(&dst, 0, sizeof(dst));
    size_t cnt;
    mpz_export(dst._limbs, &cnt, -1, 4, 0, 0, src);
}

/* ---------- Implementation class ---------- */
class SolverImpl {
public:
    int device_id;
    cudaDeviceProp device_props;
    cgbn_error_report_t *error_report;
    
    SolverImpl(int dev_id) : device_id(dev_id), error_report(nullptr) {
        CUDA_CHECK(cudaSetDevice(device_id));
        CUDA_CHECK(cudaGetDeviceProperties(&device_props, device_id));
        CUDA_CHECK(cgbn_error_report_alloc(&error_report));
    }
    
    ~SolverImpl() {
        if (error_report) {
            cgbn_error_report_free(error_report);
        }
    }
    
    size_t get_optimal_batch_size() const {
        // Heuristic based on GPU memory and compute capability
        size_t base_batch = 10000;
        if (device_props.major >= 7) {  // Volta and newer
            base_batch = 20000;
        }
        return base_batch;
    }
    
    SolveResult solve_single(const PuzzleParams& params) {
        SolveResult result;
        result.success = false;
        
        try {
            // Parse parameters
            mpz_t n, a, C;
            mpz_inits(n, a, C, nullptr);
            
            if (mpz_set_str(n, params.n, 16) != 0 ||
                mpz_set_str(a, params.a, 16) != 0 ||
                mpz_set_str(C, params.C, 16) != 0) {
                mpz_clears(n, a, C, nullptr);
                result.error_msg = "Invalid hex input";
                return result;
            }
            
            // Prepare GPU instance
            gpu_inst h_inst{};
            mpz_to_cgbn(h_inst.n, n);
            mpz_to_cgbn(h_inst.a, a);
            mpz_to_cgbn(h_inst.C, C);
            h_inst.T = params.T;
            
            // Allocate device memory
            gpu_inst *d_inst;
            CUDA_CHECK(cudaMalloc(&d_inst, sizeof(gpu_inst)));
            CUDA_CHECK(cudaMemcpy(d_inst, &h_inst, sizeof(gpu_inst), 
                                  cudaMemcpyHostToDevice));
            
            // Launch kernel (1 instance)
            int threads = 128;
            int blocks = 1;
            rsw_kernel<<<blocks, threads>>>(error_report, d_inst, 1);
            
            CUDA_CHECK(cudaDeviceSynchronize());
            CGBN_CHECK(error_report);
            
            // Get result
            CUDA_CHECK(cudaMemcpy(&h_inst, d_inst, sizeof(gpu_inst), 
                                  cudaMemcpyDeviceToHost));
            
            memcpy(result.key, h_inst.key, 32);
            result.success = true;
            
            // Cleanup
            CUDA_CHECK(cudaFree(d_inst));
            mpz_clears(n, a, C, nullptr);
            
        } catch (const std::exception& e) {
            result.error_msg = e.what();
        }
        
        return result;
    }
    
    std::vector<SolveResult> solve_batch_impl(const std::vector<PuzzleParams>& params_batch) {
        std::vector<SolveResult> results(params_batch.size());
        
        if (params_batch.empty()) return results;
        
        try {
            // Prepare host batch
            std::vector<gpu_inst> h_batch(params_batch.size());
            
            for (size_t i = 0; i < params_batch.size(); i++) {
                mpz_t n, a, C;
                mpz_inits(n, a, C, nullptr);
                
                if (mpz_set_str(n, params_batch[i].n, 16) != 0 ||
                    mpz_set_str(a, params_batch[i].a, 16) != 0 ||
                    mpz_set_str(C, params_batch[i].C, 16) != 0) {
                    mpz_clears(n, a, C, nullptr);
                    results[i].success = false;
                    results[i].error_msg = "Invalid hex input";
                    continue;
                }
                
                mpz_to_cgbn(h_batch[i].n, n);
                mpz_to_cgbn(h_batch[i].a, a);
                mpz_to_cgbn(h_batch[i].C, C);
                h_batch[i].T = params_batch[i].T;
                
                mpz_clears(n, a, C, nullptr);
            }
            
            // Allocate device memory
            gpu_inst *d_batch;
            size_t batch_size = h_batch.size();
            CUDA_CHECK(cudaMalloc(&d_batch, sizeof(gpu_inst) * batch_size));
            CUDA_CHECK(cudaMemcpy(d_batch, h_batch.data(), 
                                  sizeof(gpu_inst) * batch_size, 
                                  cudaMemcpyHostToDevice));
            
            // Calculate grid dimensions
            int threads = 128;
            int instances_per_block = threads / TPI;
            int blocks = (batch_size + instances_per_block - 1) / instances_per_block;
            
            // Launch kernel
            rsw_kernel<<<blocks, threads>>>(error_report, d_batch, batch_size);
            
            CUDA_CHECK(cudaDeviceSynchronize());
            CGBN_CHECK(error_report);
            
            // Get results
            CUDA_CHECK(cudaMemcpy(h_batch.data(), d_batch, 
                                  sizeof(gpu_inst) * batch_size, 
                                  cudaMemcpyDeviceToHost));
            
            // Copy keys to results
            for (size_t i = 0; i < batch_size; i++) {
                if (results[i].error_msg.empty()) {
                    memcpy(results[i].key, h_batch[i].key, 32);
                    results[i].success = true;
                }
            }
            
            // Cleanup
            CUDA_CHECK(cudaFree(d_batch));
            
        } catch (const std::exception& e) {
            for (auto& result : results) {
                if (!result.success && result.error_msg.empty()) {
                    result.error_msg = e.what();
                }
            }
        }
        
        return results;
    }
};

/* ---------- Solver implementation ---------- */
Solver::Solver(int device_id) : impl(std::make_unique<SolverImpl>(device_id)) {}

Solver::~Solver() = default;

Solver::Solver(Solver&&) noexcept = default;
Solver& Solver::operator=(Solver&&) noexcept = default;

SolveResult Solver::solve(const PuzzleParams& params) {
    return impl->solve_single(params);
}

std::vector<SolveResult> Solver::solve_batch(const std::vector<PuzzleParams>& params_batch) {
    return impl->solve_batch_impl(params_batch);
}

size_t Solver::get_optimal_batch_size() const {
    return impl->get_optimal_batch_size();
}

std::string Solver::get_device_name() const {
    return std::string(impl->device_props.name);
}

int Solver::get_device_id() const {
    return impl->device_id;
}

/* ---------- Utility functions ---------- */
namespace util {

std::vector<uint8_t> hex_to_bytes(const std::string& hex) {
    if (hex.size() % 2 != 0) {
        throw std::invalid_argument("Hex string must have even length");
    }
    
    std::vector<uint8_t> bytes(hex.size() / 2);
    for (size_t i = 0; i < bytes.size(); i++) {
        std::string byte_str = hex.substr(i * 2, 2);
        bytes[i] = static_cast<uint8_t>(std::stoi(byte_str, nullptr, 16));
    }
    return bytes;
}

std::string bytes_to_hex(const uint8_t* data, size_t len) {
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    for (size_t i = 0; i < len; i++) {
        ss << std::setw(2) << static_cast<int>(data[i]);
    }
    return ss.str();
}

} // namespace util
} // namespace rsw