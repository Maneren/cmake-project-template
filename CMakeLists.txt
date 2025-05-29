cmake_minimum_required(VERSION 3.10)

set(PROJECT "cmake-project-template")
project(${PROJECT})

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

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
set(CMAKE_INSTALL_MESSAGE LAZY)

set(PROJECT_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include)
set(PROJECT_BIN_DIR ${PROJECT_SOURCE_DIR}/bin)
set(PROJECT_LIB_DIR ${PROJECT_SOURCE_DIR}/lib)
set(PROJECT_HEADERS_DIR ${PROJECT_SOURCE_DIR}/src/include)

add_subdirectory(src)

enable_testing()
add_subdirectory(test)
