cmake_minimum_required(VERSION 3.20)

project(
    test_example
    DESCRIPTION "The code for testing test-driver framework"
    LANGUAGES Fortran C CXX
)
include(CTest)
set(CMAKE_GENERATOR "Ninja")
add_library(test_example STATIC)

add_subdirectory(external)
add_subdirectory(core-code)
add_subdirectory(test)