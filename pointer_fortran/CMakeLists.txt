cmake_minimum_required(VERSION 3.20)

project("use_pointer"
        DESCRIPTION "test pointer operation"
        LANGUAGES Fortran C CXX)

add_executable(${PROJECT_NAME} pointer.f90)
