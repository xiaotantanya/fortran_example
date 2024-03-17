cmake_minimum_required(VERSION 3.20)

project(check_dot
        DESCRIPTION "check dot"
        VERSION 0.1.0
        LANGUAGES Fortran C CXX)

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/test.in ${CMAKE_CURRENT_BINARY_DIR}/test.in COPYONLY)
add_executable(check_dot check_dot.f90)
add_executable(read_general_first_line read_general_first_line.f90)
add_test(NAME check_dot_test COMMAND check_dot)
add_test(NAME read_general_first_line_test COMMAND read_general_first_line)