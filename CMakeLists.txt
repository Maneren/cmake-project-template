cmake_minimum_required(VERSION 3.31..4.4)

set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR})
set(CMAKE_INSTALL_MESSAGE LAZY)

set(PROJECT "cmake-project-template")
project(${PROJECT} LANGUAGES CXX)

option(SANITIZERS "Enable sanitizers" OFF)
if(SANITIZERS)
    add_compile_options(-fsanitize=address,undefined,leak)
    add_link_options(-fsanitize=address,undefined,leak)
endif()

option(THIN_ARCHIVE "Create thin archive" ON)
set_property(GLOBAL PROPERTY THIN_ARCHIVE ${THIN_ARCHIVE})

option(USE_IPO "Enable IPO" ON)
if(USE_IPO)
    include(CheckIPOSupported)

    check_ipo_supported(RESULT ipo_supported OUTPUT ipo_error LANGUAGES CXX)
    if(NOT ipo_supported)
        message(SEND_ERROR "IPO is not supported: ${ipo_error}")
    endif()

    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
endif()

option(USE_CCACHE "Use ccache" OFF)
if(USE_CCACHE)
    find_program(CCACHE ccache)
    find_program(SCCACHE sccache)
    if(CCACHE)
        message(STATUS "Found ccache: ${CCACHE}")
        set(CMAKE_C_COMPILER_LAUNCHER ${CCACHE})
        set(CMAKE_CXX_COMPILER_LAUNCHER ${CCACHE})
    elseif(SCCACHE)
        message(STATUS "Found sccache: ${SCCACHE}")
        set(CMAKE_C_COMPILER_LAUNCHER ${SCCACHE})
        set(CMAKE_CXX_COMPILER_LAUNCHER ${SCCACHE})
    else()
        message(WARNING "ccache not found")
    endif()
endif()

include(cmake/ExecutableTemplate.cmake)
include(cmake/LibraryTemplate.cmake)

add_subdirectory(src)
add_subdirectory(apps)

option(BUILD_TESTS "Build test executables" ON)
if(BUILD_TESTS)
    enable_testing()
    add_subdirectory(test)
endif()
