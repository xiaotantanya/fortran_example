cmake_minimum_required(VERSION 3.20)

project("code_name"
        DESCRIPTION "code name"
        LANGUAGES Fortran C CXX)

add_executable(${PROJECT_NAME} code_name.f90)

add_test(NAME "${PROJECT_NAME}_test" COMMAND ${PROJECT_NAME})