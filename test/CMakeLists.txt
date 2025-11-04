include(${CMAKE_SOURCE_DIR}/cmake/TestTemplate.cmake)

add_custom_target(tests
    COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure --parallel
    DEPENDS all_tests
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    COMMENT "Running all tests"
)

add_custom_target(all_tests)

add_subdirectory(unit)
