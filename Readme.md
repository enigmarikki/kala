[![crates.io](https://img.shields.io/crates/v/kala-core.svg)](https://crates.io/crates/kala-core)
[![docs.rs](https://docs.rs/kala-core/badge.svg)](https://docs.rs/kala-core)
[![Build Status](https://github.com/enigmarikki/kala/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/enigmarikki/kala/actions?query=workflow%3Aci)
[![codecov](https://codecov.io/gh/enigmarikki/kala/branch/master/graph/badge.svg)](https://codecov.io/gh/enigmarikki/kala)

# Kala: The Immutability of Time

**Version:** v0.0.2
**Author:** Hrishi
**Date:** July 24, 2025

---

## Disclaimer

All claims, content, designs, algorithms, estimates, roadmaps, specifications, and performance measurements described in this project are provided with the author’s best effort. You are encouraged to validate their accuracy and truthfulness independently. Nothing in this project constitutes a solicitation for investment.

---

## Overview

Kala is a high-performance, VDF-based blockchain architecture designed for trustless, verifiable timestamping and consensus. By leveraging sequential modular squaring in class groups and integrating RSW timelock puzzles for MEV mitigation, Kala constructs an eternal, fork-free timeline of fixed “ticks,” enabling:

* Unforgeable, fine-grained timestamping at the iteration level
* Leader-based, fork-free consensus at the tick level
* MEV-resistant transaction ordering via timelock encryption
* Graceful degradation under partial consensus failures

For full technical details, see the [project whitepaper](https://github.com/enigmarikki/kala/blob/master/whitepaper.pdf).

---

## Prerequisites

* **Rust toolchain** (stable + nightly)
  Install via:

  ```bash
  curl https://sh.rustup.rs -sSf | sh
  source $HOME/.cargo/env
  rustup component add rustfmt-preview
  ```
* **Git**
* **GNU Make** (optional, for build scripts)

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/enigmarikki/kala.git
cd kala
```

### Building

```bash
# Build all crates in debug mode
cargo build

# Build in release mode
cargo build --release
```

### Running the Dev Node

The `devnode` binary in the `kala-core` crate spins up a local node with an in-memory chain and RPC endpoint.

```bash
# Initialize or reuse the database at ./kala_db and expose RPC on port 8545
cargo run -p kala-core --bin devnode -- --db-path ./kala_db --rpc-port 8545
```

This will start the node and begin VDF tick computation immediately. The main RPC endpoint is available at:

```
http://127.0.0.1:8545
```

## Testing & Benchmarking

```bash
# Run the test suite
cargo test

# Run benchmarks (nightly required)
rustup install nightly
time cargo +nightly bench --features unstable
```

---

## Client Demo

*Coming soon!*

*Note:* The client demo is under active development. Once ready, you can run:

```bash
cargo run --release --bin kala-client-demo -- --config client.toml
```

---

## Contributing

Contributions are welcome! Please read our [Contributing Guide](./CONTRIBUTING.md) for details on code style, testing, and pull requests.

---

## License

This project is licensed under the **MIT License**. See [LICENSE](./LICENSE) for details.

---

 
