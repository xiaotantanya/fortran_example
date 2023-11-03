cmake_policy(SET CMP0076 NEW) #
cmake_policy(SET CMP0079 NEW) # allow link to MPI::MPI_Fortran

include(GNUInstallDirs)
include(add_mupro_test)
add_library(openmupro STATIC)
add_library(mupro::openmupro ALIAS openmupro)
set_target_properties(openmupro PROPERTIES DEBUG_POSTFIX ${CMAKE_DEBUG_POSTFIX})

set(openmupro_library openmupro)



set(LIB_NAME l0_base)
# find_package(toml-f)
set(SRC mpi.f90)


set(LINK_LIB MPI::MPI_Fortran toml-f exprtk)
target_sources(${openmupro_library} PRIVATE ${SRC})
target_link_libraries(${openmupro_library} PUBLIC ${LINK_LIB})

if(WIN32)
  set(OPT "/bigobj" "/EHsc" "/D_CRT_SECURE_NO_WARNINGS")
  target_compile_options(${openmupro_library}
                         PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${OPT}>)
endif()

mupro_test(${LIB_NAME} "${SRC}" "${LINK_LIB}" "" "${OPT}")


target_include_directories(
  ${openmupro_library}
  PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
         $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
         $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}/openmupro>)

debugsetup(TARGET ${openmupro_library})

set_target_properties(
  ${openmupro_library}
  PROPERTIES POSITION_INDEPENDENT_CODE TRUE
             OUTPUT_NAME ${openmupro_library}
             Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include")
if(NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/include")
  make_directory("${CMAKE_CURRENT_BINARY_DIR}/include")
endif()
