function(set_compiler_and_linker_flags TARGET)
    cmake_parse_arguments(ARGS "" "CXX_STD" "" ${ARGN})

    target_compile_options(
        ${TARGET}
        PRIVATE
            $<$<CXX_COMPILER_ID:GNU,Clang>:-Wall
            -Wextra
            -Wpedantic
            -Wconversion>
            $<$<CXX_COMPILER_ID:MSVC>:/W4>
    )

    if(ARGS_CXX_STD)
        set_target_properties(${TARGET} PROPERTIES CXX_STANDARD ${ARGS_CXX_STD})
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
        set(CXX_GNU_DEBUG_INFO -g3 -gdwarf-5 -fno-omit-frame-pointer)
        set(CXX_DEBUG_FLAGS -Og)
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        set(CXX_GNU_DEBUG_INFO /Zi)
        set(CXX_DEBUG_FLAGS /Od)
    endif()

    set(USE_DEBUG_INFO $<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>)

    target_compile_options(
        ${TARGET}
        PRIVATE
            $<$<CONFIG:Debug>:${CXX_DEBUG_FLAGS}>
            $<${USE_DEBUG_INFO}:${CXX_DEBUG_INFO}>
    )
    get_property(THIN_ARCHIVE GLOBAL PROPERTY THIN_ARCHIVE)
    if(THIN_ARCHIVE)
        set_property(
            TARGET ${TARGET}
            APPEND
            PROPERTY STATIC_LIBRARY_OPTIONS "--thin"
        )
    endif()
endfunction()

function(add_include_directories TARGET VISIBILITY DIRS)
    if(DIRS)
        target_include_directories(${TARGET} ${VISIBILITY} ${DIRS})
    endif()
endfunction()

function(set_output_directories TARGET TYPE)
    if(TYPE STREQUAL "LIBRARY")
        set_target_properties(
            ${TARGET}
            PROPERTIES
                ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
                LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib
                RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        )
    elseif(TYPE STREQUAL "EXECUTABLE")
        set_target_properties(
            ${TARGET}
            PROPERTIES RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        )
    elseif(TYPE STREQUAL "TEST")
        set_target_properties(
            ${TARGET}
            PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/test/bin
                FOLDER "Tests"
        )
    endif()
endfunction()

function(set_version_properties TARGET VERSION)
    if(VERSION)
        set_target_properties(
            ${TARGET}
            PROPERTIES VERSION ${VERSION} SOVERSION ${VERSION}
        )
    endif()
endfunction()
