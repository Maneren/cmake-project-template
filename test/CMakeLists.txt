cmake_minimum_required(VERSION 3.10)
project(${PROJECT}_tests LANGUAGES CXX)

include(FetchContent)
FetchContent_Declare(
  googletest
  EXCLUDE_FROM_ALL
  URL https://github.com/google/googletest/archive/7da55820cc32dedd6c1b048f2d4e13fdde5e8237.zip
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

enable_testing()
add_custom_target(tests ${CMAKE_CTEST_COMMAND} DEPENDS ${PROJECT}_tests)

include_directories(${DIVISION_HEADERS_DIR})
file(GLOB_RECURSE TEST_FILES main.cpp src/*.cpp src/*.h)
add_executable(${PROJECT}_tests EXCLUDE_FROM_ALL ${TEST_FILES})
target_link_libraries(${PROJECT}_tests division gtest)

include(GoogleTest)
gtest_discover_tests(${PROJECT}_tests)
