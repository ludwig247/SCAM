project(RISCV_gtest C CXX)
cmake_minimum_required(VERSION 2.8)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 ${LLVM_CXX_FLAGS} ")

#INCLUDE DIRECTORIES
include_directories(/usr/local/systemc/include)

add_executable(RISCV_gtest tests.cpp ISA_tests.h)
target_link_libraries(RISCV_gtest gtest gtest_main pthread)
