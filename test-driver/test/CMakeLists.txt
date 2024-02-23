# if(NOT TARGET "test-drive::test-drive")
#     find_package("test-drive" REQUIRED)
#   endif()
add_library(test-drive::test-drive ALIAS test-drive)
  # Unit testing
  set(
    tests
    "suite1"
    "suite2"
  )
  set(
    test-srcs
    "main.f90"
  )
  foreach(t IN LISTS tests)
    string(MAKE_C_IDENTIFIER ${t} t) 
    list(APPEND test-srcs "test_${t}.f90")
  endforeach()
  
  add_executable(
    "${PROJECT_NAME}-tester"
    "${test-srcs}"
  )
  target_link_libraries(
    "${PROJECT_NAME}-tester"
    PRIVATE
    # "${PROJECT_NAME}-lib"
    ${PROJECT_NAME}
    "test-drive::test-drive"
  )
  # message(${PROJECT_NAME})
  message(${CMAKE_CURRENT_BINARY_DIR})
  message("${PROJECT_NAME}-tester")
  message("${PROJECT_NAME}-test")
  # add_test(
  #     NAME "${PROJECT_NAME}-test"
  #     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  #     COMMAND "test_example-tester"
  #   )
  foreach(t IN LISTS tests)
    # add_test(
    #   NAME "${PROJECT_NAME}-${t}"
    #   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    #   COMMAND "${PROJECT_NAME}-tester"
    # )
    add_test("${PROJECT_NAME}/${t}" "${PROJECT_NAME}-tester" "${t}")
  endforeach()