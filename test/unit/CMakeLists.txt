create_test_executable(division_tests
    SOURCES division/division_tests.cpp
    PRIVATE_DEPS division
    GTEST
)

add_dependencies(all_tests division_tests)
