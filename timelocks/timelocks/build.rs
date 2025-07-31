use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    println!("cargo:rerun-if-changed=../rsw_solver.cu");
    println!("cargo:rerun-if-changed=../rsw_solver.h");
    println!("cargo:rerun-if-changed=../Makefile");
    
    // Get paths
    let manifest_dir = env::var("CARGO_MANIFEST_DIR").unwrap();
    let binding = PathBuf::from(&manifest_dir);
    let timelocks_root = &binding.parent().unwrap();
    
    // Check if we need to build the CUDA library
    let lib_dir = timelocks_root.join("lib");
    let lib_path = lib_dir.join("librsw_solver.a");
    
    if !lib_path.exists() {
        println!("cargo:warning=Building RSW CUDA library...");
        
        // Run make in the parent directory
        let status = Command::new("make")
            .current_dir(&timelocks_root)
            .arg("lib")
            .arg(format!("SM={}", env::var("CUDA_SM").unwrap_or_else(|_| "75".to_string())))
            .status()
            .expect("Failed to run make");
        
        if !status.success() {
            panic!(
                "Failed to build CUDA library. Make sure CUDA is installed and run 'make lib' in {}",
                timelocks_root.display()
            );
        }
    }
    
    // Build the C API wrapper
    cc::Build::new()
        .cpp(true)
        .file(timelocks_root.join("solver_api.cpp"))
        .include(&timelocks_root)
        .include("/usr/local/cuda/include")
        .flag("-std=c++17")
        .flag("-fPIC")
        .compile("solver_api");
    
    // Tell cargo where to find libraries
    println!("cargo:rustc-link-search=native={}", lib_dir.display());
    
    // CUDA paths
    if let Ok(cuda_path) = env::var("CUDA_PATH") {
        println!("cargo:rustc-link-search=native={}/lib64", cuda_path);
    } else {
        println!("cargo:rustc-link-search=native=/usr/local/cuda/lib64");
        println!("cargo:rustc-link-search=native=/opt/cuda/lib64");
    }
    
    // Link libraries
    println!("cargo:rustc-link-lib=static=solver_api");
    println!("cargo:rustc-link-lib=static=rsw_solver");
    println!("cargo:rustc-link-lib=cudart");
    println!("cargo:rustc-link-lib=gmp");
    println!("cargo:rustc-link-lib=stdc++");
}