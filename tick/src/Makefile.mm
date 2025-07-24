# Makefile.mm  ── build & run the VDF benchmark

# -------- toolchain --------
CXX      ?= g++
CXXFLAGS ?= -std=c++20 -O3 -march=native -pipe -g                        \
            -pthread -fPIC -mavx2 -mbmi -mbmi2 -mlzcnt                  \
            -I. -I../include -I../refcode

# -------- linker --------
LDFLAGS  ?= -L.. -ltick -flto
LDLIBS   ?= -lgmpxx -lgmp -lboost_system -pthread

# -------- sources / targets --------
TARGET = vdf
SRC    = mm.cpp            # rename if your file isn’t mm.cpp
OBJ    = $(SRC:.cpp=.o)

# default target
all: $(TARGET)

# build the final binary
$(TARGET): $(OBJ) ../libtick.a
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) $(LDLIBS) -o $@

# compile object file(s)
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# quick bench: `make run`
run: $(TARGET)
	./$(TARGET) 65536

clean:
	rm -f $(TARGET) $(OBJ)

.PHONY: all run clean
