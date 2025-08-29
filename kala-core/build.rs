// Build script for kala-core - CVDF version
//
// This build script is for the new CVDF implementation that doesn't require
// the old tick C++ library. The CVDF streaming is implemented entirely in Rust
// using the kala-tick crate.

fn main() {
    // The kala-core crate now uses the CVDF streaming implementation
    // which is entirely Rust-based and doesn't require C++ bindings.
    // This build script is kept minimal for potential future native optimizations.

    println!("cargo:rerun-if-changed=build.rs");
    println!("cargo:warning=kala-core now uses CVDF streaming - no C++ dependencies required");
}
