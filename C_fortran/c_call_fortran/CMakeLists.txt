cmake_minimum_required(VERSION 3.20)
add_executable(c_call_fortran showhie.f90 c2fortran.c)
add_test(NAME c_call_fortran_test COMMAND c_call_fortran)