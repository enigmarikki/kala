use std::env;
use std::path::PathBuf;
use std::process::Command;

fn main() {
    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    
    let schema_file = manifest_dir.join("./schema/tx.fbs");
    
    // Generate directly to src/generated/
    let output_dir = manifest_dir.join("src/kalav1");
    
    // Create the output directory if it doesn't exist
    std::fs::create_dir_all(&output_dir).expect("Failed to create output directory");
    
    // Tell Cargo to rerun if schema changes
    println!("cargo:rerun-if-changed={}", schema_file.display());
    
    // Generate the Rust code
    let output = Command::new("flatc")
        .args(&[
            "--rust",
            "-o", output_dir.to_str().unwrap(),
            schema_file.to_str().unwrap(),
        ])
        .output()
        .expect("Failed to execute flatc");
    
    if !output.status.success() {
        panic!(
            "flatc failed: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }
}