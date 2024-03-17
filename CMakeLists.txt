cmake_minimum_required(VERSION 3.20)

project(FORTRAN_STUDY
        DESCRIPTION "Fortran Study Example"
        VERSION 0.1.0
        LANGUAGES Fortran C CXX)


include(CTest)
add_subdirectory(base_knowledge)
add_subdirectory(C_fortran)
add_subdirectory(check_dot)
add_subdirectory(common)
add_subdirectory(dimension_subroutine_test)
add_subdirectory(dynamic_allocate)
# TODO: will compelte in furture