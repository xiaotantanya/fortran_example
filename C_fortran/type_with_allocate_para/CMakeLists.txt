cmake_minimum_required(VERSION 3.20)

# project("type_with_allocate_para"
#         DESCRIPTION "type with allocate parameter"
#         VERSION 0.1.0
#         LANGUAGES Fortran C)

add_executable(type_with_allocate_para fortran_code.f90 main.c)
add_test(NAME type_with_allocate_para_test COMMAND type_with_allocate_para)