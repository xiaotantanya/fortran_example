cmake_minimum_required(VERSION 3.20)

project(dynamic_allocate
        VERSION 0.1.0
        DESCRIPTION "dynamic allocate program"
        LANGUAGES Fortran C CXX)

add_executable(allocate_array allocate_array.f90)
add_executable(allocated_to_not_allocate allocated_to_not_allocate.f90)

add_test(NAME allocate_array_test COMMAND allocate_array)
add_test(NAME allocated_to_not_allocate_test COMMAND allocated_to_not_allocate)