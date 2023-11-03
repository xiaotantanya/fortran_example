# cmake_minimum_required(VERSION 3.15)

# project( fson DESCRIPTION "json parser for Fortran" LANGUAGES Fortran)

add_library(fson STATIC fson.f90 fson_path_m.f90 fson_string_m.f90
                        fson_value_m.f90)
target_include_directories(
  fson PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)
# install(TARGETS fson DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/ )
# install(DIRECTORY ${CMAKE_Fortran_MODULE_DIRECTORY} DESTINATION
# ${CMAKE_CURRENT_BINARY_DIR})

# include_directories(${CMAKE_CURRENT_BINARY_DIR})

include(GNUInstallDirs)

install(
  TARGETS fson
  EXPORT fsonTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

install(
  EXPORT fsonTargets
  FILE fsonTargets.cmake
  NAMESPACE fson::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/fson)

include(CMakePackageConfigHelpers)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/fsonConfigVersion.cmake"
  VERSION "2.0"
  COMPATIBILITY AnyNewerVersion)

# create config file
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/fsonConfig.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/fsonConfig.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/fson)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/fsonConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/fsonConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/fson)
export(
  EXPORT fsonTargets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/fsonTargets.cmake"
  NAMESPACE fson::)
