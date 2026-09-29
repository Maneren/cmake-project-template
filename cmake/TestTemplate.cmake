include(${CMAKE_CURRENT_LIST_DIR}/CommonUtils.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ExecutableTemplate.cmake)
include(GoogleTest)

function(create_test_executable TARGET)
    cmake_parse_arguments(
        TEST
        ""
        "CXX_STD"
        "SOURCES;DEPENDS;COMPILE_DEFS;INCLUDE_DIRS"
        ${ARGN}
    )

    if(NOT TEST_SOURCES)
        file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS *.cpp *.c)
        if(NOT TEST_SOURCES)
            message(FATAL_ERROR "No test sources for ${TARGET}")
        endif()
    endif()

    create_executable(
        ${TARGET}
        "${TEST_SOURCES}"
        TEST
        CXX_STD ${TEST_CXX_STD}
        DEPENDS GTest::gtest GTest::gtest_main ${TEST_DEPENDS}
        COMPILE_DEFS
            ${TEST_COMPILE_DEFS}
            TESTING_ENABLED=1
            $<$<CONFIG:Debug>:DEBUG_TESTS=1>
        INCLUDE_DIRS ${TEST_INCLUDE_DIRS}
    )

    gtest_discover_tests(${TARGET})
endfunction()
