#ifndef TICK_H
#define TICK_H

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>

// Opaque handle types
typedef struct tick_form* tick_form_t;
typedef struct tick_reducer* tick_reducer_t;
typedef struct tick_square_state* tick_square_state_t;

// Initialize the library
void tick_init();

// Form management
tick_form_t tick_form_create();
void tick_form_destroy(tick_form_t form);
tick_form_t tick_form_generator(const char* discriminant_hex);

// Get form values as hex strings (caller must free returned strings)
char* tick_form_get_a(tick_form_t form);
char* tick_form_get_b(tick_form_t form);
char* tick_form_get_c(tick_form_t form);

// Set form values from hex strings
void tick_form_set_a(tick_form_t form, const char* hex_value);
void tick_form_set_b(tick_form_t form, const char* hex_value);
void tick_form_set_c(tick_form_t form, const char* hex_value);

// Reducer management
tick_reducer_t tick_reducer_create();
void tick_reducer_destroy(tick_reducer_t reducer);
void tick_reducer_reduce(tick_reducer_t reducer, tick_form_t form);

// Square state management
tick_square_state_t tick_square_state_create(int pairindex);
void tick_square_state_destroy(tick_square_state_t state);

// VDF operations
uint64_t tick_repeated_square_fast(
    tick_square_state_t state,
    tick_form_t form,
    const char* discriminant_hex,
    uint64_t iterations
);

void tick_nudupl_form(
    tick_form_t result,
    tick_form_t input,
    const char* discriminant_hex
);

#ifdef __cplusplus
}
#endif

#endif // TICK_H