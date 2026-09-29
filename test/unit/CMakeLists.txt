create_test_executable(
    division_tests
    SOURCES division/division_tests.cpp
    DEPENDS division
    CXX_STD 23
)

add_dependencies(all_tests division_tests)
