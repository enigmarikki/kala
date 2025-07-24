cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()

project(tick)

# Find required packages
find_package(Threads REQUIRED)

# Set compiler flags to match the Makefile
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mavx2 -mbmi -mbmi2 -mlzcnt -fvisibility=hidden -fpermissive -Wno-error")
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
endif()

add_compile_definitions(VDF_MODE=1 FAST_MACHINE=1)

# Build compile_asm executable (without PIC, matching the Makefile)
add_executable(compile_asm
  ${CMAKE_CURRENT_SOURCE_DIR}/compile_asm.cpp
)

# Set specific flags for compile_asm to match Makefile
if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
  set_target_properties(compile_asm PROPERTIES 
    COMPILE_FLAGS "-std=c++1z -D VDF_MODE=1 -D FAST_MACHINE=1 -pthread -no-pie -O3 -g"
    LINK_FLAGS "-flto -no-pie -g"
  )
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  set_target_properties(compile_asm PROPERTIES 
    COMPILE_FLAGS "-std=c++1z -D VDF_MODE=1 -D FAST_MACHINE=1 -pthread -fno-PIE -O3 -g"
    LINK_FLAGS "-flto -fno-PIE -g"
  )
endif()

target_link_libraries(compile_asm 
  gmpxx
  gmp
  boost_system
  Threads::Threads
)

# Custom commands to generate assembly files in the source directory
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/asm_compiled.s
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/compile_asm
  DEPENDS compile_asm
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Generating asm_compiled.s"
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/avx2_asm_compiled.s
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/compile_asm avx2
  DEPENDS compile_asm
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Generating avx2_asm_compiled.s"
)

add_custom_command(
  OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/avx512_asm_compiled.s
  COMMAND ${CMAKE_CURRENT_BINARY_DIR}/compile_asm avx512
  DEPENDS compile_asm
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  COMMENT "Generating avx512_asm_compiled.s"
)

# Custom target to ensure assembly files are generated
add_custom_target(generate_asm 
  DEPENDS 
    ${CMAKE_CURRENT_SOURCE_DIR}/asm_compiled.s
    ${CMAKE_CURRENT_SOURCE_DIR}/avx2_asm_compiled.s
    ${CMAKE_CURRENT_SOURCE_DIR}/avx512_asm_compiled.s
)

# Create static library
add_library(tick_static STATIC
  ${CMAKE_CURRENT_SOURCE_DIR}/tick.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/refcode/lzcnt.c
  ${CMAKE_CURRENT_SOURCE_DIR}/asm_compiled.s
  ${CMAKE_CURRENT_SOURCE_DIR}/avx2_asm_compiled.s
  ${CMAKE_CURRENT_SOURCE_DIR}/avx512_asm_compiled.s
)

# Ensure assembly files are generated before building the library
add_dependencies(tick_static generate_asm)

target_include_directories(tick_static PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}/refcode
)

# Set compile flags for tick.cpp to match Makefile
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/tick.cpp PROPERTIES
  COMPILE_FLAGS "-std=c++1z -D VDF_MODE=1 -D FAST_MACHINE=1 -pthread -fPIC -O3 -g -fvisibility=hidden -mavx2 -mbmi -mbmi2 -mlzcnt -fpermissive -Wno-error"
)

# Set compile flags for lzcnt.c to match Makefile
set_source_files_properties(${CMAKE_CURRENT_SOURCE_DIR}/refcode/lzcnt.c PROPERTIES
  COMPILE_FLAGS "-O3 -fPIC"
)

target_link_libraries(tick_static
  gmpxx
  gmp
  boost_system
  Threads::Threads
)

set_target_properties(tick_static PROPERTIES
  OUTPUT_NAME tick
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/static"
)