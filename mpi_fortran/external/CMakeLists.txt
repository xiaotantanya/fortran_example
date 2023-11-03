add_subdirectory(exprtk ${CMAKE_CURRENT_BINARY_DIR}/../exprtk)
add_subdirectory(fson ${CMAKE_CURRENT_BINARY_DIR}/../fson)
add_subdirectory(toml-f ${CMAKE_CURRENT_BINARY_DIR}/../toml-f)
# add_subdirectory(pFUnit)

include(GNUInstallDirs)

include(CMakePackageConfigHelpers)

# generate the version file for the config file
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/../toml-f/toml-fConfigVersion.cmake"
  VERSION "0.4.1"
  COMPATIBILITY AnyNewerVersion)

# create config file
configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/toml-fConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/../toml-f/toml-fConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/toml-f)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/../toml-f/toml-fConfig.cmake"
              "${CMAKE_CURRENT_BINARY_DIR}/../toml-f/toml-fConfigVersion.cmake"
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/toml-f)

export(
  EXPORT toml-f-targets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/../toml-f/toml-f-targets.cmake"
  NAMESPACE toml-f::)


include(RequiredMPI)
# include(RequiredOpenSSL)

DebugSetup(TARGET "toml-f-lib")
DebugSetup(TARGET fson)

# if(WIN32)
#   target_compile_options(
#     "toml-f-lib"
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:$<$<CONFIG:DEBUG>:/Zi
#            /Z7
#            /O0
#            /debug:full
#            /traceback
#            /check
#            /Qinit:arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:$<$<CONFIG:DEBUG>:/Zi /Z7 /O0 /debug:full
#            /traceback>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:$<$<CONFIG:DEBUG>:/Zi /Z7 /O0 /debug:full
#            /traceback>>)
# else()
#   target_compile_options(
#     "toml-f-lib"
#     PUBLIC "-diag-disable=10441"
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:$<$<CONFIG:DEBUG>:-g -traceback -O0
#            -check -init=arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:$<$<CONFIG:DEBUG>:-g -traceback -O0>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:$<$<CONFIG:DEBUG>:-g -traceback -O0>>)
# endif()

# if(WIN32)
#   target_compile_options(
#     "fson"
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:$<$<CONFIG:DEBUG>:/Zi
#            /Z7
#            /O0
#            /debug:full
#            /traceback
#            /check
#            /Qinit:arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:$<$<CONFIG:DEBUG>:/Zi /Z7 /O0 /debug:full
#            /traceback>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:$<$<CONFIG:DEBUG>:/Zi /Z7 /O0 /debug:full
#            /traceback>>)
# else()
#   target_compile_options(
#     "fson"
#     PUBLIC "-diag-disable=10441"
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:$<$<CONFIG:DEBUG>:-g -traceback -O0
#            -check -init=arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:$<$<CONFIG:DEBUG>:-g -traceback -O0>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:$<$<CONFIG:DEBUG>:-g -traceback -O0>>)
# endif()
