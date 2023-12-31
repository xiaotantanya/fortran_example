# find_package(MKL CONFIG REQUIRED)
set(C_OPT "")
set(LINK_OPT "")
set(libname text)

if(WIN32)
  list(APPEND C_OPT "-D_CRT_SECURE_NO_WARNINGS")
  if(CMAKE_C_COMPILER_ID STREQUAL "ICL")
    list(APPEND C_OPT "/Qdiag-disable:1478")
  endif()
endif()

file(GLOB SRC_LIST CONFIGURE_DEPENDS
     "${PROJECT_SOURCE_DIR}/library/ntextutils.c"
     "${PROJECT_SOURCE_DIR}/library/ntextutils.f90")
file(GLOB HEADER_LIST CONFIGURE_DEPENDS
     "${PROJECT_SOURCE_DIR}/include/ntextutils/*.h")

add_library(${libname} STATIC)
add_library(mupro::${libname} ALIAS ${libname})
target_sources(${libname} PRIVATE ${SRC_LIST} ${HEADER_LIST})
set_property(TARGET ${libname} PROPERTY C_STANDARD 99)

target_include_directories(${libname} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include
                                             ${CMAKE_CURRENT_BINARY_DIR})
target_compile_options(${libname} PUBLIC ${C_OPT})
target_link_libraries(${libname} PUBLIC zf_log ${LINK_OPT})
DebugSetup(TARGET ${libname})

# if(WIN32)
#   target_compile_options(
#     ${libname}
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
#     ${libname}
#     PUBLIC "-diag-disable=10441"
#     PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:-i8;$<$<CONFIG:DEBUG>:-g -traceback -O0
#            -check -init=arrays>>
#     PUBLIC $<$<COMPILE_LANGUAGE:C>:-DMKL_ILP64;$<$<CONFIG:DEBUG>:-g -traceback
#            -O0>>
#     PUBLIC $<$<COMPILE_LANGUAGE:CXX>:-DMKL_ILP64;$<$<CONFIG:DEBUG>:-g
#            -traceback -O0>>)
# endif()

source_group(
  TREE "${PROJECT_SOURCE_DIR}/include"
  PREFIX "Header Files"
  FILES ${HEADER_LIST})
