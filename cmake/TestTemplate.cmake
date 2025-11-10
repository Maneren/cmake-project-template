include(${CMAKE_CURRENT_LIST_DIR}/CommonUtils.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ExecutableTemplate.cmake)

function(create_test_executable TARGET)
    cmake_parse_arguments(TEST
        "GTEST;CUSTOM"
        "FRAMEWORK;CXX_STD"
        "SOURCES;PRIVATE_DEPS;COMPILE_DEFS;INCLUDE_DIRS"
        ${ARGN}
    )

    if(NOT TEST_SOURCES)
        file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS *.cpp *.c)
        if(NOT TEST_SOURCES)
            message(FATAL_ERROR "No test sources for ${TARGET}")
        endif()
    endif()

    create_executable(${TARGET}
        "${TEST_SOURCES}"
        TEST
        CXX_STD ${TEST_CXX_STD}
        PRIVATE_DEPS ${TEST_PRIVATE_DEPS}
        COMPILE_DEFS ${TEST_COMPILE_DEFS}
            TESTING_ENABLED=1 $<$<CONFIG:Debug>:DEBUG_TESTS=1>
        INCLUDE_DIRS ${TEST_INCLUDE_DIRS}
    )

    if(TEST_GTEST OR TEST_FRAMEWORK STREQUAL "gtest")
        setup_gtest(${TARGET})
    elseif(TEST_CUSTOM)
    else()
        message(FATAL_ERROR "Unknown test framework ${TEST_FRAMEWORK}")
    endif()
endfunction()

function(setup_gtest TARGET)
    find_package(GTest QUIET)

    if(TARGET GTest::GTest)
        target_link_libraries(${TARGET} PRIVATE GTest::GTest GTest::Main)
    elseif(EXISTS ${CMAKE_SOURCE_DIR}/test/external/googletest/CMakeLists.txt)
        add_subdirectory(${CMAKE_SOURCE_DIR}/test/external/googletest EXCLUDE_FROM_ALL)
        target_link_libraries(${TARGET} PRIVATE gtest gtest_main)
    else()
        message(FATAL_ERROR "GoogleTest not found. Install it or run 'git submodule update --init --recursive'")
    endif()

    include(GoogleTest)

    gtest_discover_tests(${TARGET})
endfunction()
