cmake_minimum_required(VERSION 3.20)

project(total
        DESCRIPTION "total description"
        VERSION 0.1.0
        LANGUAGES Fortran C CXX)

add_subdirectory(c_call_fortran)
add_subdirectory(fortran_call_c)
add_subdirectory(type_with_allocate_para)