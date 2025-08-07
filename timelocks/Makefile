############################################################################
#  RSW Solver Library Makefile
#  --------------------------------------------------------------
#  Targets:
#     make lib      → Build static library (librsw_solver.a)
#     make shared   → Build shared library (librsw_solver.so)
#     make example  → Build example program
#     make all      → Build everything
#     make clean    → Clean build artifacts
#
#  GPU Architecture (set SM variable or use target):
#     make lib SM=75        → Build for specific compute capability
#     make volta-lib        → Build for Volta (sm_70)
#     make turing-lib       → Build for Turing (sm_75)
#     make ampere-lib       → Build for Ampere (sm_80)
#     make ada-lib          → Build for Ada Lovelace (sm_89)
############################################################################

# Default compute capability (Turing)
SM ?= 75

###################### Optional paths ######################
ifdef GMP_HOME
  GMP_INC = -I$(GMP_HOME)/include
  GMP_LIB = -L$(GMP_HOME)/lib
else
  GMP_INC =
  GMP_LIB =
endif

# CGBN location (adjust if needed)
CGBN_DIR ?= ./CGBN

###################### Compiler settings ####################
NVCC = nvcc
CXX = g++

# NVCC flags
NVCCFLAGS = -std=c++17 -O3 \
            -I$(CGBN_DIR)/include \
            $(GMP_INC) \
            -Xcompiler -fPIC \
            -arch=sm_$(SM)

# C++ flags for non-CUDA files
CXXFLAGS = -std=c++17 -O3 -fPIC -I. -I$(CUDA_PATH)/include $(GMP_INC)

# CUDA path (adjust if needed)
CUDA_PATH ?= /usr/local/cuda

# Linker flags
LDFLAGS = $(GMP_LIB) -lgmp -L$(CUDA_PATH)/lib64 -lcudart

###################### Output directories ###################
BUILD_DIR = build
LIB_DIR = lib
BIN_DIR = bin

# Create directories
$(shell mkdir -p $(BUILD_DIR) $(LIB_DIR) $(BIN_DIR))

###################### Targets ##############################

# Main targets
all: lib shared example c_api

lib: $(LIB_DIR)/librsw_solver.a

shared: $(LIB_DIR)/librsw_solver.so

example: $(BIN_DIR)/bench

c_api: $(BUILD_DIR)/rsw_solver_c_api.o

# Build static library
$(LIB_DIR)/librsw_solver.a: $(BUILD_DIR)/rsw_solver.o
	ar rcs $@ $^
	@echo "Built static library: $@"

# Build shared library
$(LIB_DIR)/librsw_solver.so: $(BUILD_DIR)/rsw_solver.o
	$(NVCC) -shared -o $@ $^ $(LDFLAGS)
	@echo "Built shared library: $@"

# Compile CUDA source
$(BUILD_DIR)/rsw_solver.o: rsw_solver.cu rsw_solver.h
	$(NVCC) $(NVCCFLAGS) -c $< -o $@

# Build example program
$(BIN_DIR)/bench: bench.cpp $(LIB_DIR)/librsw_solver.a
	$(CXX) $(CXXFLAGS) $< -L$(LIB_DIR) -lrsw_solver $(LDFLAGS) -o $@
	@echo "Built example: $@"

# Build C API wrapper
$(BUILD_DIR)/rsw_solver_c_api.o: solver_api.cpp rsw_solver.h $(BUILD_DIR)/rsw_solver.o
	$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "Built C API wrapper"

###################### Architecture targets ##################
# Convenience targets for different GPU architectures
volta-lib:
	$(MAKE) lib SM=70

turing-lib:
	$(MAKE) lib SM=75

ampere-lib:
	$(MAKE) lib SM=80

ada-lib:
	$(MAKE) lib SM=89

# Build for multiple architectures
multi-arch-lib:
	$(MAKE) clean
	$(NVCC) $(NVCCFLAGS) \
	        -gencode arch=compute_70,code=sm_70 \
	        -gencode arch=compute_75,code=sm_75 \
	        -gencode arch=compute_80,code=sm_80 \
	        -gencode arch=compute_86,code=sm_86 \
	        -gencode arch=compute_89,code=sm_89 \
	        -c rsw_solver.cu -o $(BUILD_DIR)/rsw_solver.o
	ar rcs $(LIB_DIR)/librsw_solver.a $(BUILD_DIR)/rsw_solver.o
	@echo "Built multi-arch static library"

###################### Installation ##########################
PREFIX ?= /usr/local

install: lib
	install -d $(PREFIX)/lib
	install -d $(PREFIX)/include
	install -m 644 $(LIB_DIR)/librsw_solver.a $(PREFIX)/lib/
	install -m 644 rsw_solver.h $(PREFIX)/include/
	@echo "Installed to $(PREFIX)"

uninstall:
	rm -f $(PREFIX)/lib/librsw_solver.a
	rm -f $(PREFIX)/include/rsw_solver.h

###################### Testing ###############################
# Test with the example puzzle from the original code
test: example
	@echo "Running test with example RSW puzzle..."
	$(BIN_DIR)/bench \
	  c7c892a5b55ee1e631a3d90471a6171f939f1653d20e8de088e7a38e5f8e6a6cd42074e6c9c96cd903f0071e09f9c2af5ae80f92e783bc6faaeb35d5754cf14e936c3bfc3e66f0de961b91b5c8a96e39c1b973a0c185d08c8f31f02d825861c9eecedec13c8c55bb07ceeb1cf96e2a7d \
	  2 \
	  7c2fc0dbac319e93e3c43e2b9bf68e940e8b8a10e973bb63c88f73dd7b4f14b4df47c2f0fb60b94406ca959fb1f3a8cf8e4cb63e1cd5b99afd26b4cc1d08c09f5b3fb72ca01b96a7a7c12ca97f3d0ba7d85c87b18b3f666de9f45f05f7e3bfc99c6fc5b8f5b3e8c973bb2fb8ebf6cf2 \
	  120000

###################### Utilities ############################
# Show build configuration
info:
	@echo "=== Build Configuration ==="
	@echo "Compute Capability: sm_$(SM)"
	@echo "CGBN Directory: $(CGBN_DIR)"
	@echo "GMP Include: $(GMP_INC)"
	@echo "GMP Library: $(GMP_LIB)"
	@echo "Install Prefix: $(PREFIX)"

# Clean build artifacts
clean:
	rm -rf $(BUILD_DIR) $(LIB_DIR) $(BIN_DIR)
	@echo "Cleaned build artifacts"

.PHONY: all lib shared example clean install uninstall test info \
        volta-lib turing-lib ampere-lib ada-lib multi-arch-lib