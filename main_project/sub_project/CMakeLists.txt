
project(
  "sub-drive"
  LANGUAGES "Fortran"
  VERSION "0.4.0"
  DESCRIPTION "The simple testing framework"
)

message("Sub Project " ${PROJECT_BINARY_DIR})
message("Sub Project " ${CMAKE_CURRENT_SOURCE_DIR})
message("Sub Project " ${CMAKE_CURRENT_BINARY_DIR})
message("Sub Project " ${CMAKE_INSTALL_LIBDIR})