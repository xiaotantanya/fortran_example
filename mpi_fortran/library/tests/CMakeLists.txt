# target_sources(${LIB_NAME} PRIVATE lib.f90)

set(EXE_NAME L0_Base)

add_executable(${EXE_NAME} test_lb.f90)
# configure_file(${CMAKE_CURRENT_SOURCE_DIR}/input.toml
#                ${CMAKE_CURRENT_BINARY_DIR}/input.toml
#                COPYONLY)
target_link_libraries(${EXE_NAME} PRIVATE mupro::${LIB_NAME})
set_target_properties(${EXE_NAME} PROPERTIES LINKER_LANGUAGE Fortran)


add_test(
  NAME ${EXE_NAME}
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  COMMAND ${EXE_NAME})
