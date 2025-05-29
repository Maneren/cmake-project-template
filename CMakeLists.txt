cmake_minimum_required(VERSION 3.10)

project(cmake-project-template)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Set compiler flags for Debug and RelWithDebInfo builds
set(
	CMAKE_CXX_FLAGS_DEBUG
	"${CMAKE_CXX_FLAGS_DEBUG} -Wall -Wextra -pedantic -g3 -gdwarf-5 -fno-omit-frame-pointer"
)
set(
	CMAKE_CXX_FLAGS_RELWITHDEBINFO
	"${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -g3 -gdwarf-5 -fno-omit-frame-pointer"
)

set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR})

set(DIVISIBLE_INSTALL_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)
set(DIVISIBLE_INSTALL_BIN_DIR ${PROJECT_SOURCE_DIR}/bin)
set(DIVISIBLE_INSTALL_LIB_DIR ${PROJECT_SOURCE_DIR}/lib)

set(DIVISION_HEADERS_DIR ${PROJECT_SOURCE_DIR}/src/division)

include_directories(${DIVISIBLE_INSTALL_INCLUDE_DIR})
include_directories(${DIVISION_HEADERS_DIR})

add_subdirectory(src)
add_subdirectory(test)
