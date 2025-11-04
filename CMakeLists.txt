cmake_minimum_required(VERSION 3.25)

set(PROJECT "cmake-project-template")
project(${PROJECT})

set(CMAKE_CXX_EXTENSIONS OFF)
set(DEFAULT_CXX_STD 23)

set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR})
set(CMAKE_INSTALL_MESSAGE LAZY)

include(cmake/ExecutableTemplate.cmake)
include(cmake/LibraryTemplate.cmake)

add_subdirectory(src)
add_subdirectory(apps)

option(BUILD_TESTS "Build test executables" ON)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()
