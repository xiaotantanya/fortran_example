cmake_minimum_required(VERSION 3.20)

add_executable(fortran_call_c main.f90 sub.c)
add_test(NAME fortran_call_c_test COMMAND fortran_call_c)