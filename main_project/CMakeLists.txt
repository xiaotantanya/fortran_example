cmake_minimum_required(VERSION 3.9)
# get_directory_property(is-subproject PARENT_DIRECTORY)

project(
  "test-drive"
  LANGUAGES "Fortran"
  VERSION "0.4.0"
  DESCRIPTION "The simple testing framework"
)
message("Main Project " ${PROJECT_BINARY_DIR})
message("Main Project " ${CMAKE_CURRENT_SOURCE_DIR})
message("Main Project " ${CMAKE_CURRENT_BINARY_DIR})
message("Main Project " ${CMAKE_INSTALL_LIBDIR})
add_subdirectory(sub_project)