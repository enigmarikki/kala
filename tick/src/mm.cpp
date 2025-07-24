#include "include.h"
#include "double_utility.h"
#include "integer.h"
#include "vdf_new.h"
#include "nucomp.h"
#include "proof_common.h"
#include "threading.h"
#include "vdf_fast.h"
#include <cstdlib>

int main(int argc, char **argv) {
    init_gmp();
    set_rounding_mode();
    int iters = atoi(argv[1]);
    auto D = integer("-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679");

    form y = form::generator(D);
    integer L = root(-D, 4);
    int i, n_slow = 0;
    PulmarkReducer reducer;
    bool is_asm = true, is_comp = true;
    auto t1 = std::chrono::high_resolution_clock::now();
    
    for (i = 0; i < iters; ) {
        square_state_type sq_state;
        sq_state.pairindex = 0;
        uint64_t done;

        // Force only 32 iterations at a time
        done = repeated_square_fast(sq_state, y, D, L, 0, 32, NULL);
        if (!done) {
            nudupl_form(y, y, D, L);
            reducer.reduce(y);
            i++;
            n_slow++;
        } else if (done == ~0ULL) {
            printf("Fail\n");
            break;
        } else {
            i += done;
        }
    }
    
    auto t2 = std::chrono::high_resolution_clock::now();
    int duration = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1).count();
    if (!duration) {
        printf("WARNING: too few iterations, results will be inaccurate!\n");
        duration = 1;
    }
    printf("Time: %d ms; ", duration);
    if (is_comp) {
        if (is_asm)
            printf("n_slow: %d; ", n_slow);

        printf("speed: %d.%dK ips\n", iters/duration, iters*10/duration % 10);
        printf("a = %s\n", y.a.to_string().c_str());
        printf("b = %s\n", y.b.to_string().c_str());
        printf("c = %s\n", y.c.to_string().c_str());
    } else {
        printf("speed: %d.%d ms/discr\n", duration/iters, duration*10/iters % 10);
    }
    return 0;
}