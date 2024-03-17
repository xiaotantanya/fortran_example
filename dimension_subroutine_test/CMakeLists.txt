cmake_minimum_required(VERSION 3.20)

project(dimension_subroutine_test
        DESCRIPTION "common fortran program"
        VERSION 0.1.0
        LANGUAGES Fortran C CXX)

# include(CTest)

add_executable(${PROJECT_NAME} dimension_subroutine.f90)
add_test(NAME ${PROJECT_NAME}_test COMMAND ${PROJECT_NAME})