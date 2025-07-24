# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-src"
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-build"
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix"
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix/tmp"
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix/src/pybind11-src-populate-stamp"
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix/src"
  "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix/src/pybind11-src-populate-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix/src/pybind11-src-populate-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/rikki/Desktop/kala/build/_deps/pybind11-src-subbuild/pybind11-src-populate-prefix/src/pybind11-src-populate-stamp${cfgdir}") # cfgdir has leading slash
endif()
