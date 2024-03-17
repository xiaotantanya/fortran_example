cmake_minimum_required(VERSION 3.20)

project(common
        DESCRIPTION "common fortran program"
        VERSION 0.1.0
        LANGUAGES Fortran C CXX)

include(CTest)

add_executable(function_first function_first.f90)
add_executable(generate_random_num generate_random_num.f90)
add_executable(module_example module_example.f90)
add_executable(optional_parameter optional_paramter.f90)
add_executable(pointer pointer.f90)
add_executable(test_reshape test_reshape.f90)

add_test(NAME function_first_test COMMAND function_first)
add_test(NAME generate_random_num_test COMMAND generate_random_num)
add_test(NAME module_example_test COMMAND module_example)
add_test(NAME optional_parameter_test COMMAND optional_parameter)
add_test(NAME pointer_test COMMAND pointer)
add_test(NAME test_reshape_test COMMAND test_reshape)