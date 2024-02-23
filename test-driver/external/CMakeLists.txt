cmake_minimum_required(VERSION 3.20)

add_subdirectory(test-drive ${CMAKE_CURRENT_BINARY_DIR}/../test-drive)

# target_compile_options(
#       test-drive
#       PUBLIC $<$<COMPILE_LANGUAGE:Fortran>:
#             #  -i8
#              -heap-arrays
#              -init=arrays
#              -init=zero
#              $<$<CONFIG:DEBUG>:
#              -O0
#              #-warn all
#              #-check all
#              -nowarn
#              -nocheck
#              -g
#              -traceback
#              # -no-simd
#              -standard-semantics
#              -fp-model=precise>
#              $<$<CONFIG:RELEASE>:-O3
#              -fp-model=fast>>
#       PUBLIC $<$<COMPILE_LANGUAGE:C,CXX>:-DMKL_LP64
#              $<$<CONFIG:DEBUG>:-g
#              -O0
#              -debug
#              full>
#              $<$<CONFIG:RELEASE>:-O3
#              -fp-model=fast>>)
# target_link_options(test-drive PUBLIC $<$<CONFIG:DEBUG>:-g -O0>)