cmake_minimum_required(VERSION 3.20)

project(
  openmupro
  DESCRIPTION "The open common Mu-PRO SDK utilities"
  LANGUAGES Fortran)


enable_language(Fortran)
set(CMAKE_Fortran_COMPILER "ifort")

find_package(MPI)
if(NOT TARGET MPI::MPI_Fortran)
add_library(MPI::MPI_Fortran IMPORTED INTERFACE GLOBAL)
set_property(TARGET MPI::MPI_Fortran PROPERTY INTERFACE_COMPILE_OPTIONS
                                                ${MPI_Fortran_COMPILE_FLAGS})
set_property(TARGET MPI::MPI_Fortran PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                                                ${MPI_Fortran_INCLUDE_PATH})
set_property(
    TARGET MPI::MPI_Fortran
    PROPERTY INTERFACE_LINK_LIBRARIES ${MPI_Fortran_LINK_FLAGS}
            ${MPI_Fortran_LIBRARIES})
endif()

add_executable(test example_out.f90)
set(LINK_LIB MPI::MPI_Fortran)
target_link_libraries(test PUBLIC ${LINK_LIB})
