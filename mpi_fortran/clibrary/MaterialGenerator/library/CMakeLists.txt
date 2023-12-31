set(INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include ${niobasic_mod_dir} ${nmathfft_SOURCE_DIR}/include ${zf_log_SOURCE_DIR})
set(C_OPT "")
set(LINK_OPT "")

if(WIN32)
    list(APPEND C_OPT "-D_CRT_SECURE_NO_WARNINGS")

    if(CMAKE_C_COMPILER_ID STREQUAL "ICL")
        list(APPEND C_OPT "/Qdiag-disable:1478")
    endif()
endif()

file(GLOB HEADER_LIST CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/library/include/nmaterialgenerator/*.h")
file(GLOB LIB_SRC CONFIGURE_DEPENDS
    "${PROJECT_SOURCE_DIR}/library/property/*.c"
    "${PROJECT_SOURCE_DIR}/library/material/*.c")

set(libname material)
add_library(${libname} STATIC)
add_library(mupro::${libname} ALIAS ${libname})
target_sources(${libname} PRIVATE ${LIB_SRC} ${HEADER_LIST})
set_property(TARGET ${libname} PROPERTY C_STANDARD 99)

target_link_libraries(${libname} PUBLIC zf_log mupro::text mupro::io mupro::math ${LINK_OPT})
target_compile_options(${libname} PUBLIC ${C_OPT})
target_include_directories(${libname} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR})

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
    TREE "${PROJECT_SOURCE_DIR}/library/include"
    PREFIX "Header Files"
    FILES ${HEADER_LIST}
)