cmake_minimum_required(VERSION 3.10)

set(TEST_EXECUTABLE ${PROJECT}_tests)

project(${TEST_EXECUTABLE} LANGUAGES CXX)

add_custom_target(tests ${CMAKE_CTEST_COMMAND} DEPENDS ${PROJECT}_tests)

include_directories(${PROJECT_HEADERS_DIR})

file(GLOB_RECURSE TEST_FILES main.cpp src/*.cpp src/*.h)
add_executable(${TEST_EXECUTABLE} EXCLUDE_FROM_ALL ${TEST_FILES})

target_link_libraries(${TEST_EXECUTABLE}
  PRIVATE
    division
)

find_package(GTest QUIET)

if(TARGET GTest::GTest)
  target_link_libraries(${TEST_EXECUTABLE}
    PRIVATE
      GTest::GTest
      GTest::Main
  )
elseif(EXISTS ./test/external/googletest/CMakeLists.txt)
  add_subdirectory(external/googletest EXCLUDE_FROM_ALL)
  include_directories(external/googletest/googletest/include)
  add_dependencies(${TEST_EXECUTABLE} gtest)
  target_link_libraries(${TEST_EXECUTABLE} PRIVATE gtest)
else()
  message(
    FATAL_ERROR
    "Could not find googletest, try installing it or running
      'git submodule update --init --recursive'"
  )
endif()

include(GoogleTest)
gtest_discover_tests(${PROJECT}_tests)
