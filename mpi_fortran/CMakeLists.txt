cmake_minimum_required(VERSION 3.20)

project(
  openmupro
  DESCRIPTION "The open common Mu-PRO SDK utilities"
  LANGUAGES C CXX Fortran)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)
message(STATUS "CMAKE_MODULE_PATH in openmupro " ${CMAKE_MODULE_PATH})
include(Version)

include(DebugSetup)
include(CPackConfig)
include(GNUInstallDirs)
include(CTest)
include(add_mupro_test)

add_subdirectory(external)
add_subdirectory(library)

