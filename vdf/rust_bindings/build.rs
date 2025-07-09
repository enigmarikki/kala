use std::env;
use std::path::PathBuf;

fn main() {
    /* ── 0.  Paths ──────────────────────────────────────────────────────── */
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap()); // rust_bindings/
    let project_root = manifest_dir
        .parent()
        .expect("crate must be inside <project>/rust_bindings");
    let src_dir = project_root.join("src");
    assert!(
        src_dir.exists(),
        "Cannot find project-level src directory at {}",
        src_dir.display()
    );
    let c_bindings_dir = src_dir.join("c_bindings");
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());

    /* ── 1.  Rebuild triggers ───────────────────────────────────────────── */
    println!("cargo:rerun-if-changed=build.rs");
    println!(
        "cargo:rerun-if-changed={}",
        c_bindings_dir.join("streamer.cpp").display()
    );
    println!(
        "cargo:rerun-if-changed={}",
        c_bindings_dir.join("streamer.h").display()
    );
    println!("cargo:rerun-if-changed={}", src_dir.join("vdf.h").display());

    /* ── 2.  Compile streamer.cpp (static lib) ──────────────────────────── */
    let mut cc_build = cc::Build::new();
    cc_build
        .cpp(true)
        .std("c++17")
        .file(c_bindings_dir.join("streamer.cpp"))
        .include(&src_dir)
        .include(&c_bindings_dir)
        .flag_if_supported("-w") // silence 3rd-party warnings
        .opt_level(3)
        .define("VDF_MODE", "0")
        .define("FAST_MACHINE", "1");

    /* platform flags */
    #[cfg(target_os = "linux")]
    {
        cc_build.flag("-fPIC").flag("-pthread");
    }
    #[cfg(target_os = "macos")]
    {
        cc_build.flag("-fPIC").flag("-stdlib=libc++");
    }
    #[cfg(target_os = "windows")]
    {
        cc_build.flag("/EHsc").flag("/std:c++17");
    }
    #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
    {
        cc_build.flag_if_supported("-march=native");
    }

    cc_build.compile("cpu_vdf_streamer"); // produces libcpu_vdf_streamer.a

    /* ── 3.  Link the pre-built core objects ────────────────────────────── */
    let prebuilt_objs = [
        "lzcnt.o",
        "asm_compiled.o",
        "avx2_asm_compiled.o",
        "avx512_asm_compiled.o",
    ];
    for obj in &prebuilt_objs {
        let p = src_dir.join(obj);
        if p.exists() {
            // Pass each .o straight to rustc’s linker
            println!("cargo:rustc-link-arg={}", p.display());
        } else {
            println!(
                "cargo:warning=expected prebuilt object {} not found",
                p.display()
            );
        }
    }

    /* Alternatively, link against the shared library shipped in the repo
    println!("cargo:rustc-link-search=native={}", src_dir.display());
    println!("cargo:rustc-link-lib=dylib=cpuvdf_no_lto");
    */

    /* ── 4.  GMP / MPIR linkage ─────────────────────────────────────────── */
    #[cfg(target_os = "windows")]
    {
        println!("cargo:rustc-link-lib=mpir");
        if let Ok(mpir_dir) = env::var("MPIR_DIR") {
            println!("cargo:rustc-link-search=native={}/lib", mpir_dir);
        }
    }
    #[cfg(not(target_os = "windows"))]
    {
        if pkg_config::probe_library("gmp").is_err() {
            println!("cargo:rustc-link-lib=gmp");
            println!("cargo:rustc-link-lib=gmpxx");
        }
    }

    /* C++ standard library & pthread */
    #[cfg(target_os = "linux")]
    println!("cargo:rustc-link-lib=stdc++");
    #[cfg(target_os = "macos")]
    println!("cargo:rustc-link-lib=c++");
    #[cfg(not(target_os = "windows"))]
    println!("cargo:rustc-link-lib=pthread");

    /* ── 5.  Generate bindings for streamer.h ───────────────────────────── */
    let bindings = bindgen::Builder::default()
        .header(
            c_bindings_dir
                .join("streamer.h")
                .to_str()
                .expect("utf-8 path"),
        )
        .clang_arg("-x")
        .clang_arg("c++")
        .clang_arg(format!("-I{}", src_dir.display()))
        .clang_arg("-std=c++14")
        .allowlist_function("cpu_vdf_.*")
        .allowlist_type("cpu_vdf_.*")
        .allowlist_var("CPU_VDF_.*")
        .derive_default(true)
        .derive_debug(true)
        .generate_comments(true)
        .prepend_enum_name(false)
        .enable_cxx_namespaces()
        .disable_name_namespacing()
        .layout_tests(false) // C++ layouts are rarely stable
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    bindings
        .write_to_file(out_dir.join("bindings.rs"))
        .expect("Couldn't write bindings!");

    println!("cargo:warning=CPU-VDF build script completed");
}
