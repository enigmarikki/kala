use std::env;
use std::path::PathBuf;

fn main() {
    // Tell cargo to look for the static library in the src directory
    println!("cargo:rustc-link-search=native=../src");

    // Link the static library
    println!("cargo:rustc-link-lib=static=tick");

    // Link the required C++ libraries
    println!("cargo:rustc-link-lib=gmpxx");
    println!("cargo:rustc-link-lib=gmp");
    println!("cargo:rustc-link-lib=boost_system");
    println!("cargo:rustc-link-lib=stdc++");
    println!("cargo:rustc-link-lib=pthread");

    // CRITICAL: Disable PIE to work with the assembly code
    println!("cargo:rustc-link-arg=-no-pie");

    // Tell cargo to invalidate the built crate whenever the wrapper changes
    println!("cargo:rerun-if-changed=../src/tick.h");
    println!("cargo:rerun-if-changed=../src/libtick.a");

    // Use bindgen to generate Rust bindings
    let bindings = bindgen::Builder::default()
        .header("../src/tick.h")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        // Opaque types for the C++ wrapper structs
        .opaque_type("tick_form")
        .opaque_type("tick_reducer")
        .opaque_type("tick_square_state")
        // Allowlist all tick_ functions and types
        .allowlist_function("tick_.*")
        .allowlist_type("tick_.*")
        .generate()
        .expect("Unable to generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}
