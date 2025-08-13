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

All claims, content, designs, algorithms, estimates, roadmaps, specifications, and performance measurements described in this project are provided with the author's best effort. You are encouraged to validate their accuracy and truthfulness independently. Nothing in this project constitutes a solicitation for investment.

---

## Overview

Kala is a high-performance, VDF-based blockchain architecture designed for trustless, verifiable timestamping and consensus. By leveraging sequential modular squaring in class groups and integrating RSW timelock puzzles for MEV mitigation, Kala constructs an eternal, fork-free timeline of fixed "ticks," enabling:

* Unforgeable, fine-grained timestamping at the iteration level
* Leader-based, fork-free consensus at the tick level
* MEV-resistant transaction ordering via timelock encryption
* Graceful degradation under partial consensus failures

For full technical details, see the [project whitepaper](https://github.com/enigmarikki/kala/blob/master/docs/kala_v0.0.2.pdf).

---

## Architecture

Kala implements a novel VDF-based consensus mechanism with the following key components:

### Core Components

* **Eternal VDF**: Continuous verifiable delay function creating an unstoppable timeline
* **Tick-Based Consensus**: Fixed epochs of 65,536 iterations (~497ms) for deterministic processing  
* **RSW Timelock Puzzles**: MEV-resistant transaction ordering through temporal encryption
* **GPU Acceleration**: CUDA-powered parallel timelock decryption
* **Modular Architecture**: Cleanly separated crates for consensus, state, transactions, and RPC

### The Four-Phase Tick Protocol

1. **Collection Phase** (0 to k/3): Timestamp encrypted transactions as they arrive
2. **Ordering Phase** (at k/3): Commit to canonical transaction ordering 
3. **Decryption Phase** (k/3 to 2k/3): Decrypt timelock puzzles in parallel
4. **Validation Phase** (2k/3 to k): Validate and apply decrypted transactions

---

## Quick Start Options

### Docker (Recommended)

```bash
git clone https://github.com/enigmarikki/kala.git
cd kala
docker compose up --build
```

**That's it!** The Docker setup handles all dependencies automatically.

### Native Build Prerequisites

If you prefer to build natively, you'll need:

* **Docker and Docker Compose** (for the easy path)
* **Rust toolchain** (stable + nightly)
* **System dependencies** (see below)

#### Install Rust
```bash
curl https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
rustup component add rustfmt-preview
```

---

## System Dependencies (Native Build Only)

> **Note**: Skip this section if using Docker - all dependencies are included in the container.

### Required Build Tools & Libraries

For native builds, you'll need the following system dependencies:

#### Core Build Tools
* **GCC/G++** - GNU Compiler Collection
* **Clang/LLVM** - Required for bindgen and some Rust crates
* **CMake** - Cross-platform build system
* **pkg-config** - Helper tool for compiling applications

#### Required Libraries
* **libgmp-dev** - GNU Multiple Precision Arithmetic Library
* **libclang-dev** - Clang development libraries (for bindgen)
* **m4** - Macro processor (required for GMP builds)
* **autoconf/automake/libtool** - GNU build system tools

#### CUDA Support (if using GPU features)
* **CUDA Toolkit** - NVIDIA CUDA development tools
* **cudart** - CUDA runtime library

#### Additional Dependencies
* **FlatBuffers** (flatc) - Efficient serialization library

### Installation

#### Ubuntu/Debian
```bash
sudo apt-get update && sudo apt-get install -y \
    build-essential \
    gcc \
    g++ \
    libgmp-dev \
    cmake \
    git \
    pkg-config \
    libclang-dev \
    clang \
    llvm-dev \
    m4 \
    autoconf \
    automake \
    libtool \
    flatbuffers
```

#### macOS
```bash
# Install Xcode Command Line Tools
xcode-select --install

# Using Homebrew
brew install gmp cmake pkg-config llvm flatbuffers m4 autoconf automake libtool
```

#### Arch Linux
```bash
sudo pacman -S base-devel gcc gmp cmake pkgconf clang llvm flatbuffers m4 autoconf automake libtool
```

---

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/enigmarikki/kala.git
cd kala
```

## Option 1: Docker (Recommended) 🐳

The easiest way to run Kala is using Docker, which handles all system dependencies and build configuration automatically.

### Prerequisites

* **Docker** and **Docker Compose**
* **NVIDIA Docker runtime** (optional, for GPU acceleration)

### Quick Start with Docker

```bash
# Build and start the Kala node (includes all dependencies)
docker compose up --build

# Or run in detached mode
docker compose up --build -d
```

This will:
- Build a complete Kala development environment with all native dependencies
- Compile the native VDF libraries (C++) and timelock puzzles (CUDA)
- Build all Rust crates with optimizations
- Start the `devnode` with persistent data storage
- Expose the RPC API on `http://localhost:8545`

### Docker Configuration

The Docker setup includes:
- **Multi-stage build** for optimized production images
- **CUDA support** for GPU-accelerated timelock solving
- **Persistent data** mounted to `./kala_dev_db`
- **Configuration volume** for easy customization

### Docker Commands

```bash
# View logs
docker compose logs -f

# Stop the node
docker compose down

# Rebuild after code changes
docker compose up --build

# Execute commands in running container
docker compose exec kala devnode --help
```

---

## Option 2: Native Build

For development or custom configurations, you can build Kala natively.

### Building

```bash
# Build all crates in debug mode
cargo build

# Build in release mode
cargo build --release
```

### Running the Dev Node

The `devnode` binary in the `kala-core` crate spins up a local node with persistent state and RPC endpoint.

```bash
# Initialize or reuse the database at ./kala_db and expose RPC on port 8545
cargo run -p kala-core --bin devnode -- --db-path ./kala_db --rpc-port 8545

# For faster development (1-second ticks instead of ~500ms)
cargo run -p kala-core --bin devnode -- --fast --db-path ./kala_dev_db
```

### API Access

The RPC endpoint will be available at:

```
http://127.0.0.1:8545
```

Example API call:
```bash
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"kala_chainInfo","id":1}' \
  http://127.0.0.1:8545
```

---

## Testing & Benchmarking

### Using Docker

```bash
# Run tests in container
docker compose exec kala cargo test

# Run benchmarks (if available)
docker compose exec kala cargo bench
```

### Native Testing

```bash
# Run the test suite
cargo test

# Run benchmarks (nightly required)
rustup install nightly
time cargo +nightly bench --features unstable
```

---

## Monitoring & Observability

### Real-time Monitoring

```bash
# Watch node logs in real-time
docker compose logs -f kala

# Monitor VDF progress and tick processing
curl -s http://localhost:8545 -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"kala_chainInfo","id":1}' | jq
```

### Key Metrics to Monitor

* **Tick Progress**: Current tick number and VDF iteration
* **Transaction Throughput**: Transactions processed per tick
* **Timing Performance**: Actual vs. expected tick duration (~497ms)
* **MEV Resistance**: Transaction ordering consistency
* **GPU Utilization**: Timelock decryption performance (if GPU enabled)

### Health Checks

```bash
# Check if the node is responding
curl -f http://localhost:8545/health || echo "Node is down"

# Get recent tick information
curl -X POST http://localhost:8545 -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"kala_getRecentTicks","params":5,"id":1}'
```

---

## Development

### Hot Reloading with Docker

For development with automatic rebuilding:

```bash
# Make code changes, then rebuild
docker compose up --build

# Or use development mode (if configured)
docker compose -f docker-compose.dev.yml up
```

### Configuration

Environment variables for fine-tuning:

```bash
# In compose.yaml or your environment
RUST_LOG=debug              # Enable debug logging
KALA_FAST_MODE=true         # Use 1-second ticks for development
KALA_GPU_ENABLED=false      # Disable GPU acceleration
KALA_MAX_TXS_PER_TICK=100   # Limit transactions per tick
```

### Client SDK Development

*Coming soon!* The client SDK will provide:

```bash
# Future client demo
cargo run --release --bin kala-client-demo -- --config client.toml
```

### API Examples

```bash
# Submit a transaction (example format)
curl -X POST http://localhost:8545 -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "kala_submitTransaction", 
    "params": {
      "encrypted_tx": "0x1234567890abcdef..."
    },
    "id": 1
  }'

# Get account information
curl -X POST http://localhost:8545 -H "Content-Type: application/json" \
  -d '{
    "jsonrpc": "2.0",
    "method": "kala_getAccount",
    "params": {
      "address": "0x1234567890abcdef1234567890abcdef12345678"
    },
    "id": 1
  }'
```

---

## Performance & Troubleshooting

### Expected Performance

* **Tick Duration**: ~497ms (65,536 VDF iterations at 7.6μs each)
* **Transaction Throughput**: Up to 10,000 transactions per tick
* **Finality**: Single-tick finality (~500ms)
* **MEV Protection**: Complete front-running prevention through timelock ordering

### Troubleshooting Common Issues

#### Docker Build Fails
```bash
# Clean up and try again
docker compose down
docker system prune -f
docker compose up --build --no-cache
```

#### Node Performance Issues
```bash
# Check system resources
docker stats kala-node

# Enable debug logging
docker compose logs -f kala | grep -E "(WARN|ERROR)"

# Check VDF timing consistency
curl -s http://localhost:8545 -X POST -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"kala_chainInfo","id":1}' | jq '.result'
```

#### GPU Acceleration Not Working
```bash
# Verify NVIDIA Docker runtime
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

# Check container GPU access
docker compose exec kala nvidia-smi
```

#### Database Issues
```bash
# Reset the database (WARNING: destroys all data)
docker compose down
sudo rm -rf ./kala_dev_db
docker compose up --build
```

### Production Deployment

For production deployments, consider:

* **Resource Requirements**: 8+ CPU cores, 16GB+ RAM, SSD storage
* **Network Configuration**: Proper firewall rules for port 8545
* **GPU Optimization**: NVIDIA RTX 4090 or better for optimal timelock decryption
* **Monitoring**: Prometheus metrics integration (coming soon)
* **Backup Strategy**: Regular database snapshots of `./kala_dev_db`

---

## Contributing

Kala is an open-source research project. Contributions are welcome!

### Development Setup

1. Fork the repository
2. Set up development environment: `docker compose up --build`
3. Make your changes
4. Run tests: `docker compose exec kala cargo test`
5. Submit a pull request

### Research Areas

We're actively researching:
* **Scalability**: Optimizing VDF computation for higher throughput
* **Network Layer**: P2P networking for multi-node deployments  
* **Light Clients**: Efficient verification without full VDF computation
* **Cross-chain Integration**: Bridging with other blockchain networks

---

## License

This project is licensed under the **MIT License**. See [LICENSE](./LICENSE) for details.

---

## Citation

If you use Kala in your research, please cite:

```bibtex
@misc{kala2025,
  title={Kala: The Immutability of Time - VDF-Based Consensus with MEV Resistance},
  author={Hrishi},
  year={2025},
  url={https://github.com/enigmarikki/kala}
}
```

**"kālo'smi loka-kṣaya-kṛt pravṛddho"** - *I am Time, the destroyer of worlds*
