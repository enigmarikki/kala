#include "include.h"
#include "bit_manipulation.h"
#include "parameters.h"

// Define the extern variables from parameters.h
bool use_divide_table = true;
int gcd_base_bits = 1000;
int gcd_128_max_iter = 3;
std::string asmprefix = "vdf_";
bool enable_all_instructions = false;

// Forward declare what we need from asm_code namespace
namespace asm_code {
    struct asm_func_gcd_unsigned_data {
        uint64_t* a;
        uint64_t* b;
        uint64_t* a_2;
        uint64_t* b_2;
        uint64_t* threshold;
        uint64_t uv_counter_start;
        uint64_t* out_uv_counter_addr;
        uint64_t* out_uv_addr;
        int iter;
        int a_end_index;
    };
    
    extern "C" {
        int asm_avx2_func_gcd_unsigned(asm_func_gcd_unsigned_data* data);
        int asm_cel_func_gcd_unsigned(asm_func_gcd_unsigned_data* data);
    }
    
    // Stub declarations for AVX512 functions that avx512_integer.h expects
    template<int a, int b>
    int asm_avx512_func_to_avx512_integer(...) { return 0; }
    
    template<int a, int b>
    int asm_avx512_func_to_gmp_integer(...) { return 0; }
    
    template<int a, int b, int c>
    int asm_avx512_func_add(...) { return 0; }
    
    template<int a, int b, int c>
    int asm_avx512_func_multiply(...) { return 0; }
}

#include "picosha2.h"
#include "double_utility.h"
#include "integer.h"
#include "threading.h"
#include "avx512_integer.h"
#include "vdf_new.h"
#include "nucomp.h"
#include "proof_common.h"
#include "vdf_fast.h"
#include "tick.h"
#include <cstdlib>
#include <cstring>

// Wrapper structs
struct tick_form {
    form f;
};

struct tick_reducer {
    PulmarkReducer* reducer;
};

struct tick_square_state {
    square_state_type state;
    int pairindex;
};

// Global initialization flag
static bool g_initialized = false;

extern "C" {

void tick_init() {
    if (!g_initialized) {
        init_gmp();
        set_rounding_mode();
        g_initialized = true;
    }
}

// Form management
tick_form_t tick_form_create() {
    tick_form_t f = new tick_form;
    mpz_init(f->f.a.impl);
    mpz_init(f->f.b.impl);
    mpz_init(f->f.c.impl);
    return f;
}

void tick_form_destroy(tick_form_t form) {
    if (form) {
        delete form;
    }
}

tick_form_t tick_form_generator(const char* discriminant_hex) {
    tick_form_t f = new tick_form;
    integer D(discriminant_hex);
    f->f = form::generator(D);
    return f;
}

char* tick_form_get_a(tick_form_t form) {
    if (!form) return nullptr;
    std::string str = form->f.a.to_string();
    char* result = (char*)malloc(str.length() + 1);
    strcpy(result, str.c_str());
    return result;
}

char* tick_form_get_b(tick_form_t form) {
    if (!form) return nullptr;
    std::string str = form->f.b.to_string();
    char* result = (char*)malloc(str.length() + 1);
    strcpy(result, str.c_str());
    return result;
}

char* tick_form_get_c(tick_form_t form) {
    if (!form) return nullptr;
    std::string str = form->f.c.to_string();
    char* result = (char*)malloc(str.length() + 1);
    strcpy(result, str.c_str());
    return result;
}

void tick_form_set_a(tick_form_t form, const char* hex_value) {
    if (form && hex_value) {
        form->f.a = integer(hex_value);
    }
}

void tick_form_set_b(tick_form_t form, const char* hex_value) {
    if (form && hex_value) {
        form->f.b = integer(hex_value);
    }
}

void tick_form_set_c(tick_form_t form, const char* hex_value) {
    if (form && hex_value) {
        form->f.c = integer(hex_value);
    }
}

// Reducer management
tick_reducer_t tick_reducer_create() {
    tick_reducer_t r = new tick_reducer;
    r->reducer = new PulmarkReducer();
    return r;
}

void tick_reducer_destroy(tick_reducer_t reducer) {
    if (reducer) {
        delete reducer->reducer;
        delete reducer;
    }
}

void tick_reducer_reduce(tick_reducer_t reducer, tick_form_t form) {
    if (reducer && form) {
        reducer->reducer->reduce(form->f);
    }
}

// Square state management
tick_square_state_t tick_square_state_create(int pairindex) {
    tick_square_state_t s = new tick_square_state;
    s->pairindex = pairindex;
    s->state.pairindex = pairindex;
    return s;
}

void tick_square_state_destroy(tick_square_state_t state) {
    if (state) {
        delete state;
    }
}

uint64_t tick_repeated_square_fast(
    tick_square_state_t state,
    tick_form_t form,
    const char* discriminant_hex,
    uint64_t iterations
) {
    if (!state || !form || !discriminant_hex) return ~0ULL;
    
    try {
        integer D(discriminant_hex);
        integer L = root(-D, 4);
        
        // Debug: print form values before calling
        std::cerr << "Form before: a=" << form->f.a.to_string().substr(0, 20) 
                  << ", b=" << form->f.b.to_string().substr(0, 20) << std::endl;
        std::cerr << "D bits: " << D.num_bits() << ", L bits: " << L.num_bits() 
                  << ", a bits: " << form->f.a.num_bits() << std::endl;
        
        uint64_t result = repeated_square_fast(state->state, form->f, D, L, 0, iterations, nullptr);
        
        return result;
    } catch (const std::exception& e) {
        std::cerr << "tick_repeated_square_fast: exception: " << e.what() << std::endl;
        return ~0ULL;
    } catch (...) {
        std::cerr << "tick_repeated_square_fast: unknown exception" << std::endl;
        return ~0ULL;
    }
}

void tick_nudupl_form(
    tick_form_t result,
    tick_form_t input,
    const char* discriminant_hex
) {
    if (!result || !input || !discriminant_hex) return;
    
    integer D(discriminant_hex);
    integer L = root(-D, 4);
    
    result->f = input->f;
    nudupl_form(result->f, result->f, D, L);
}

} // extern "C"