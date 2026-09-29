include(${CMAKE_CURRENT_LIST_DIR}/CommonUtils.cmake)

function(create_library TARGET)
    cmake_parse_arguments(
        LIB
        "STATIC;SHARED;OBJECT;INTERFACE"
        "VERSION;CXX_STD;HEADER_BASE_DIR"
        "PRIVATE_DEPS;PUBLIC_DEPS;INTERFACE_DEPS;HEADERS;SOURCES"
        ${ARGN}
    )

    if(NOT LIB_INTERFACE AND NOT LIB_SOURCES)
        message(
            FATAL_ERROR
            "Library ${TARGET} has no sources but is not header-only"
        )
    endif()

    if(LIB_INTERFACE)
        add_library(${TARGET} INTERFACE)
    elseif(LIB_SHARED)
        add_library(${TARGET} SHARED ${LIB_SOURCES})
        set_target_properties(${TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    elseif(LIB_OBJECT)
        add_library(${TARGET} OBJECT ${LIB_SOURCES})
    elseif(LIB_STATIC)
        add_library(${TARGET} STATIC ${LIB_SOURCES})
    else()
        add_library(${TARGET} ${LIB_SOURCES})
    endif()

    if(LIB_HEADERS)
        if(NOT LIB_HEADER_BASE_DIR)
            set(LIB_HEADER_BASE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/include)
        endif()

        target_sources(
            ${TARGET}
            PUBLIC
                FILE_SET HEADERS
                    BASE_DIRS ${LIB_HEADER_BASE_DIR}
                    FILES ${LIB_HEADERS}
        )
    endif()

    if(LIB_INTERFACE)
        if(LIB_PRIVATE_DEPS OR LIB_PUBLIC_DEPS)
            message(
                FATAL_ERROR
                "Header-only '${TARGET}' may only have interface dependencies"
            )
        endif()
        target_link_libraries(${TARGET} INTERFACE "${LIB_INTERFACE_DEPS}")
    else()
        target_link_libraries(
            ${TARGET}
            PUBLIC "${LIB_PUBLIC_DEPS}"
            INTERFACE "${LIB_INTERFACE_DEPS}"
            PRIVATE "${LIB_PRIVATE_DEPS}"
        )

        set_compiler_and_linker_flags(${TARGET} CXX_STD ${LIB_CXX_STD})

        set_target_properties(${TARGET} PROPERTIES OUTPUT_NAME ${TARGET})
        set_output_directories(${TARGET} LIBRARY)
        set_version_properties(${TARGET} "${LIB_VERSION}")
    endif()
endfunction()

function(auto_create_library TARGET)
    # NOTE: all arguments are forwarded to create_library() verbatim via ARGN.
    # This parse only declares the accepted keywords (for reference and for
    # formatters); its results are intentionally unused.
    cmake_parse_arguments(
        LIB
        "STATIC;SHARED;OBJECT;INTERFACE"
        "VERSION;CXX_STD;HEADER_BASE_DIR"
        "PRIVATE_DEPS;PUBLIC_DEPS;INTERFACE_DEPS;HEADERS;SOURCES"
        ${ARGN}
    )

    file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.cpp src/*.cxx src/*.cc)
    file(GLOB_RECURSE HEADERS CONFIGURE_DEPENDS include/*.h include/*.hpp)

    create_library(${TARGET} ${ARGN} SOURCES "${SOURCES}" HEADERS "${HEADERS}")
endfunction()
