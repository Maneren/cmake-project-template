cmake_minimum_required(VERSION 3.10)
project(divider_tests)

add_subdirectory(lib/googletest)

include_directories(${DIVISION_HEADERS_DIR})
include_directories(lib/googletest/googletest/include)

file(GLOB_RECURSE TEST_FILES main.cpp ./src/*.cpp ./src/*.h)

add_executable(divider_tests ${TEST_FILES})
target_link_libraries(divider_tests division gtest)
install(TARGETS divider_tests DESTINATION bin)
