use std::env;
use std::path::PathBuf;

fn main() {
    // Get the directory where build.rs is located
    let manifest_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    println!("cargo:warning=CARGO_MANIFEST_DIR: {}", manifest_dir);
    
    // Navigate to the tick/src directory from kala-vdf
    let src_dir = PathBuf::from(&manifest_dir)
        .parent().unwrap()  // Go up to kala/
        .join("tick")       // Go to kala/tick/
        .join("src");       // Go to kala/tick/src/
    println!("cargo:warning=Looking for libtick.a in: {}", src_dir.display());
    
    // Check if library exists
    let lib_path = src_dir.join("libtick.a");
    if lib_path.exists() {
        println!("cargo:warning=Found libtick.a at: {}", lib_path.display());
    } else {
        println!("cargo:warning=ERROR: libtick.a not found at: {}", lib_path.display());
        panic!("libtick.a not found. Please run 'make' in the tick/src directory first.");
    }
    
    // Disable PIE - put this FIRST before other link args
    println!("cargo:rustc-link-arg=-no-pie");
    
    // Tell cargo to look for the static library using absolute path
    println!("cargo:rustc-link-search=native={}", src_dir.display());
    
    // Link against libtick.a
    println!("cargo:rustc-link-lib=static=tick");

    // Link the required C++ libraries
    println!("cargo:rustc-link-lib=gmpxx");
    println!("cargo:rustc-link-lib=gmp");
    println!("cargo:rustc-link-lib=boost_system");
    println!("cargo:rustc-link-lib=stdc++");

    // Tell cargo to invalidate the built crate whenever files change
    println!("cargo:rerun-if-changed={}", src_dir.join("tick.h").display());
    println!("cargo:rerun-if-changed={}", lib_path.display());

    // Use bindgen to generate Rust bindings
    let bindings = bindgen::Builder::default()
        .header(src_dir.join("tick.h").to_str().unwrap())
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .opaque_type("tick_form")
        .opaque_type("tick_reducer")
        .opaque_type("tick_square_state")
        .allowlist_function("tick_.*")
        .allowlist_type("tick_.*")
        .generate()
        .expect("Unable to generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}