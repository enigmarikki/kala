use std::fs;
use std::path::Path;

fn main() {
    // Tell Cargo to rerun this build script if the schema file changes
    println!("cargo:rerun-if-changed=schema/tx.fbs");
    
    // Create the output directory if it doesn't exist
    let out_dir = Path::new("src/generated");
    fs::create_dir_all(out_dir).expect("Failed to create output directory");
    
    // Generate FlatBuffers Rust code
    flatc_rust::run(flatc_rust::Args {
        inputs: &[Path::new("./schema/tx.fbs")],
        out_dir,
        ..Default::default()
    })
    .expect("Failed to generate FlatBuffers code");
    
    // Create mod.rs file to export the generated modules
    let mod_file_path = out_dir.join("mod.rs");
    
    // The module name is typically based on the schema file name
    // For tx.fbs, it would generate tx_generated.rs
    let mod_content = r#"// Auto-generated mod.rs
#![allow(unused_imports)]
#![allow(dead_code)]

pub mod tx_generated;

// Re-export commonly used items for convenience
pub use tx_generated::*;
"#;
    
    fs::write(mod_file_path, mod_content)
        .expect("Failed to write mod.rs file");
}