# Multi-stage Dockerfile for Kala Workspace

# Stage 1: Build environment
FROM nvidia/cuda:12.2.0-devel-ubuntu22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libssl-dev \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    libboost-all-dev \
    curl \
    git \
    wget \
    unzip \
    python3 \
    python3-pip \
    clang \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install flatbuffers compiler
RUN wget -q https://github.com/google/flatbuffers/releases/download/v25.2.10/Linux.flatc.binary.clang++-18.zip \
    && unzip -q Linux.flatc.binary.clang++-18.zip -d /usr/local/bin \
    && chmod +x /usr/local/bin/flatc \
    && rm Linux.flatc.binary.clang++-18.zip

# Set CUDA environment variables
ENV CUDA_HOME=/usr/local/cuda
ENV CUDA_PATH=/usr/local/cuda
ENV PATH="${CUDA_HOME}/bin:${PATH}"
ENV LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"

WORKDIR /app

COPY Cargo.toml Cargo.lock ./

# Copy all crate directories 
COPY kala-core/ ./kala-core/
COPY kala-rpc/ ./kala-rpc/
COPY kala-state/ ./kala-state/
COPY kala-transaction/ ./kala-transaction/
COPY kala-vdf/ ./kala-vdf/

# Copy native code dependencies
COPY tick/ ./tick/
COPY timelocks/ ./timelocks/

# Build native libraries first
WORKDIR /app/tick/src
RUN make clean && make -j$(nproc)

WORKDIR /app/timelocks
RUN ls -la CGBN/ || echo "CGBN directory missing"

WORKDIR /app
RUN cargo build --release --bin devnode
RUN strip target/release/devnode

# Stage 2: Runtime
FROM ubuntu:22.04

# Install minimal runtime dependencies
RUN apt-get update && apt-get install -y \
    ca-certificates \
    libssl3 \
    libgmp10 \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Create non-root user
RUN useradd -r -s /bin/false -d /data kala

# Copy the binary and required libraries
COPY --from=builder /app/target/release/devnode /usr/local/bin/devnode

# Copy native libraries (both static libs and object files if needed)
COPY --from=builder /app/tick/src/libtick.a /usr/local/lib/ 2>/dev/null || true
COPY --from=builder /app/timelocks/lib/librsw_solver.a /usr/local/lib/
COPY --from=builder /app/timelocks/build/rsw_solver.o /usr/local/lib/ 2>/dev/null || true

# Set runtime environment (no CUDA runtime needed)
ENV LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}"

# Create data directory
RUN mkdir -p /data

WORKDIR /data

# Add some debugging
RUN echo "Binary location:" && ls -la /usr/local/bin/devnode
RUN echo "Data directory:" && ls -la /data

ENTRYPOINT ["devnode"]