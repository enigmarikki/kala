use std::env;

fn main() {
    cc::Build::new()
        .cpp(true)
        .file("../solver_api.cpp")
        .include("..")
        .include("/usr/local/cuda/include")
        .flag("-std=c++17")
        .flag("-fPIC")
        .compile("solver_api");

    println!("cargo:rustc-link-search=native=../lib");

    if let Ok(cuda_path) = env::var("CUDA_PATH") {
        println!("cargo:rustc-link-search=native={cuda_path}/lib64");
    } else {
        println!("cargo:rustc-link-search=native=/usr/local/cuda/lib64");
        println!("cargo:rustc-link-search=native=/opt/cuda/lib64");
    }

    println!("cargo:rustc-link-lib=static=solver_api");
    println!("cargo:rustc-link-lib=static=rsw_solver");
    println!("cargo:rustc-link-lib=cudart");
    println!("cargo:rustc-link-lib=gmp");
    println!("cargo:rustc-link-lib=stdc++");

    println!("cargo:rerun-if-changed=../solver_api.cpp");
    println!("cargo:rerun-if-changed=../rsw_solver.h");
    println!("cargo:rerun-if-changed=../lib/librsw_solver.a");
}
