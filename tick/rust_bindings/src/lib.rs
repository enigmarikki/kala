#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

// Include the generated bindings
include!(concat!(env!("OUT_DIR"), "/bindings.rs"));

use std::ffi::{CStr, CString};
use std::sync::Once;

static INIT: Once = Once::new();

/// Initialize the VDF library (call once at program start)
pub fn init() {
    INIT.call_once(|| unsafe {
        tick_init();
    });
}

/// A VDF form (a, b, c) representing a binary quadratic form
pub struct VdfForm {
    handle: tick_form_t,
}

impl VdfForm {
    /// Create a new empty form
    pub fn new() -> Self {
        unsafe {
            VdfForm {
                handle: tick_form_create(),
            }
        }
    }

    /// Create a generator form for the given discriminant
    pub fn generator(discriminant_hex: &str) -> Self {
        let c_str = CString::new(discriminant_hex).unwrap();
        unsafe {
            VdfForm {
                handle: tick_form_generator(c_str.as_ptr()),
            }
        }
    }

    /// Copy values from another form
    pub fn copy_from(&mut self, other: &VdfForm) {
        // We need a C function to copy forms, or we can do it via values
        let (a, b, c) = other.get_values();
        self.set_a(&a);
        self.set_b(&b);
        self.set_c(&c);
    }

    /// Set form values from hex strings
    pub fn set_a(&mut self, hex_value: &str) {
        let c_str = CString::new(hex_value).unwrap();
        unsafe {
            tick_form_set_a(self.handle, c_str.as_ptr());
        }
    }

    pub fn set_b(&mut self, hex_value: &str) {
        let c_str = CString::new(hex_value).unwrap();
        unsafe {
            tick_form_set_b(self.handle, c_str.as_ptr());
        }
    }

    pub fn set_c(&mut self, hex_value: &str) {
        let c_str = CString::new(hex_value).unwrap();
        unsafe {
            tick_form_set_c(self.handle, c_str.as_ptr());
        }
    }
    pub fn get_values(&self) -> (String, String, String) {
        unsafe {
            let a_ptr = tick_form_get_a(self.handle);
            let b_ptr = tick_form_get_b(self.handle);
            let c_ptr = tick_form_get_c(self.handle);

            let a = CStr::from_ptr(a_ptr).to_string_lossy().into_owned();
            let b = CStr::from_ptr(b_ptr).to_string_lossy().into_owned();
            let c = CStr::from_ptr(c_ptr).to_string_lossy().into_owned();

            // Free the C strings
            libc::free(a_ptr as *mut libc::c_void);
            libc::free(b_ptr as *mut libc::c_void);
            libc::free(c_ptr as *mut libc::c_void);

            (a, b, c)
        }
    }
}

impl Drop for VdfForm {
    fn drop(&mut self) {
        unsafe {
            tick_form_destroy(self.handle);
        }
    }
}

// Forms are not thread-safe due to raw pointers
// (The lack of Send/Sync implementations prevents sharing across threads)

/// A reducer for normalizing forms
pub struct Reducer {
    handle: tick_reducer_t,
}

impl Reducer {
    pub fn new() -> Self {
        unsafe {
            Reducer {
                handle: tick_reducer_create(),
            }
        }
    }

    pub fn reduce(&self, form: &mut VdfForm) {
        unsafe {
            tick_reducer_reduce(self.handle, form.handle);
        }
    }
}

impl Drop for Reducer {
    fn drop(&mut self) {
        unsafe {
            tick_reducer_destroy(self.handle);
        }
    }
}

/// Square state for fast VDF computation
pub struct SquareState {
    handle: tick_square_state_t,
}

impl SquareState {
    pub fn new(pairindex: i32) -> Self {
        unsafe {
            SquareState {
                handle: tick_square_state_create(pairindex),
            }
        }
    }
}

impl Drop for SquareState {
    fn drop(&mut self) {
        unsafe {
            tick_square_state_destroy(self.handle);
        }
    }
}

/// Perform fast VDF squaring
pub fn repeated_square_fast(
    state: &mut SquareState,
    form: &mut VdfForm,
    discriminant_hex: &str,
    iterations: u64,
) -> Result<u64, String> {
    let c_discriminant = CString::new(discriminant_hex).unwrap();

    unsafe {
        let result = tick_repeated_square_fast(
            state.handle,
            form.handle,
            c_discriminant.as_ptr(),
            iterations,
        );

        if result == !0u64 {
            Err("VDF computation failed".to_string())
        } else {
            Ok(result)
        }
    }
}

/// Perform a single slow square operation (modifies form in place)
pub fn nudupl_form_inplace(form: &mut VdfForm, discriminant_hex: &str) {
    let c_discriminant = CString::new(discriminant_hex).unwrap();

    unsafe {
        tick_nudupl_form(
            form.handle,
            form.handle, // Use same handle for both input and output
            c_discriminant.as_ptr(),
        );
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::time::Instant;

    // /#[test]
    // /fn test_vdf_squaring() {
    // /    println!("Initializing VDF...");
    // /    init();
    // /
    // /    let discriminant = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";
    // /
    // /    println!("Creating generator form...");
    // /    let mut form = VdfForm::generator(discriminant);
    // /    let reducer = Reducer::new();
    // /
    // /    let (a, b, c) = form.get_values();
    // /    println!("Initial form: a={}, b={}, c={}", a, b, c);
    // /
    // /    // Reduce the initial form (generator might not return a reduced form)
    // /    println!("Reducing initial form...");
    // /    reducer.reduce(&mut form);
    // /
    // /    let (a, b, c) = form.get_values();
    // /    println!("After reduction: a={}, b={}, c={}", a, b, c);
    // /
    // /    // Run iterations - matching mm.cpp logic
    // /    let target_iterations = 100;
    // /    let mut i = 0;
    // /    let mut n_slow = 0;
    // /
    // /    println!("Starting VDF iterations...");
    // /    while i < target_iterations {
    // /        let mut sq_state = SquareState::new(0);
    // /
    // /        // Force only 32 iterations at a time (matching mm.cpp)
    // /        let done = match repeated_square_fast(&mut sq_state, &mut form, discriminant, 32) {
    // /            Ok(done) => done,
    // /            Err(e) => {
    // /                println!("Fail: {}", e);
    // /                break;
    // /            }
    // /        };
    // /
    // /        if done == 0 {
    // /            // Fall back to slow method for single iteration
    // /            nudupl_form_inplace(&mut form, discriminant);
    // /            reducer.reduce(&mut form);
    // /            i += 1;
    // /            n_slow += 1;
    // /        } else {
    // /            i += done;
    // /        }
    // /
    // /        // Safety check to prevent infinite loop
    // /        if i > 1000 {
    // /            println!("Stopping at {} iterations", i);
    // /            break;
    // /        }
    // /    }
    // /
    // /    let (a, b, c) = form.get_values();
    // /    println!("\nAfter {} iterations (n_slow={}):", i, n_slow);
    // /    println!("a = {}", a);
    // /    println!("b = {}", b);
    // /    println!("c = {}", c);
    // /}

    #[test]
    pub fn test_fast_ready_form() {
        println!("Initializing VDF...");
        init();

        let discriminant = "-141140317794792668862943332656856519378482291428727287413318722089216448567155737094768903643716404517549715385664163360316296284155310058980984373770517398492951860161717960368874227473669336541818575166839209228684755811071416376384551902149780184532086881683576071479646499601330824259260645952517205526679";

        // Create a form and advance it using slow method until it's ready for fast
        let mut form = VdfForm::generator(discriminant);
        let reducer = Reducer::new();

        println!("Warming up form with slow iterations...");
        let t0 = Instant::now();
        let mut i = 0;
        while i < 65536 {
            nudupl_form_inplace(&mut form, discriminant);
            reducer.reduce(&mut form);
            let (a, b, c) = form.get_values();
            i += 1;
        }
        let elapsed = t0.elapsed();
        //     println!("\nNow trying fast method...");
        let (a, b, c) = form.get_values();
        let mut sq_state = SquareState::new(0);

        println!("Ran {} iterations in {:?}", i, elapsed);
        println!("≈ {:.2} iter/s", i as f64 / elapsed.as_secs_f64());
        println!("a : {}, b : {}, c :{}", a, b, c);
        panic!();
    }
}
