# cmake_minimum_required(VERSION 3.15)

# project( exprtk DESCRIPTION "C++ Mathematical Expression Toolkit Library"
# LANGUAGES CXX)
include(GNUInstallDirs)

add_library(exprtk INTERFACE)
# target_sources(exprtk INTERFACE exprtk.hpp)
target_compile_features(exprtk INTERFACE cxx_std_11)
target_compile_options(
  exprtk
  INTERFACE
    $<$<AND:$<PLATFORM_ID:WIN32>,$<COMPILE_LANG_AND_ID:CXX,Intel>>:
    /bigobj
    /W4
    /WX>
    $<$<AND:$<NOT:$<PLATFORM_ID:WIN32>>,$<COMPILE_LANG_AND_ID:CXX,Intel>>:
    -Wall
    -Wextra
    -Werror
    -pedantic
    -errors>)
target_include_directories(
  exprtk INTERFACE $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>)

install(
  TARGETS exprtk
  EXPORT exprtkTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(
  EXPORT exprtkTargets
  FILE exprtkTargets.cmake
  NAMESPACE exprtk::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/exprtk)

install(
  FILES exprtk.hpp
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  COMPONENT ${PROJECT_NAME})

include(CMakePackageConfigHelpers)

# generate the version file for the config file
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/exprtkConfigVersion.cmake"
  VERSION "2.7"
  COMPATIBILITY AnyNewerVersion)

# create config file
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/exprtkConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/exprtkConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/exprtk)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/exprtkConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/exprtkConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/exprtk)

export(
  EXPORT exprtkTargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/exprtkTargets.cmake"
  NAMESPACE exprtk::)
