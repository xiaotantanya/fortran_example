# FetchContent added in CMake 3.11, downloads during the configure step
# include(FetchContent)
# # FetchContent_MakeAvailable was not added until CMake 3.14; use our shim
# if(${CMAKE_VERSION} VERSION_LESS 3.14)
#   include(cmake/add_FetchContent_MakeAvailable.cmake)
# endif()

# FetchContent_Declare(
#   zf_log
#   GIT_REPOSITORY https://github.com/billcxx/zf_log.git)
# FetchContent_MakeAvailable(zf_log)

# FetchContent_Declare(
#   libxml
#   GIT_REPOSITORY https://gitlab.gnome.org/GNOME/libxml2.git
#   GIT_TAG v2.9.10)
# FetchContent_MakeAvailable(libxml)
# message(${libxml_SOURCE_DIR} ${libxml_BINARY_DIR})

add_subdirectory(zf_log)
DebugSetup(TARGET zf_log)

# if(WIN32)
#   target_compile_options(
#     zf_log
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:$<$<CONFIG:DEBUG>:/Zi
#            /Z7
#            /4I8
#            /O0
#            /debug:full
#            /traceback
#            /check
#            /Qinit:arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:$<$<CONFIG:DEBUG>:/Zi /Z7 /DMKL_ILP64 /O0
#            /debug:full /traceback>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:$<$<CONFIG:DEBUG>:/Zi /Z7 /DMKL_ILP64 /O0
#            /debug:full /traceback>>)
# else()
#   target_compile_options(
#     zf_log
#     PUBLIC "-diag-disable=10441"
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:-i8;$<$<CONFIG:DEBUG>:-g -traceback -O0
#            -check -init=arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:-DMKL_ILP64;$<$<CONFIG:DEBUG>:-g -traceback
#            -O0>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:-DMKL_ILP64;$<$<CONFIG:DEBUG>:-g
#            -traceback -O0>>)
# endif()