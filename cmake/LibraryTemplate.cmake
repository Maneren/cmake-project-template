include(${CMAKE_CURRENT_LIST_DIR}/CommonUtils.cmake)

function(create_library TARGET SOURCES HEADERS)
    cmake_parse_arguments(LIB
        "STATIC;SHARED;HEADER_ONLY"
        "VERSION;NAMESPACE;CXX_STD"
        "PRIVATE_DEPS;PUBLIC_DEPS;INTERFACE_DEPS;COMPILE_DEFS;INCLUDE_DIRS"
        ${ARGN}
    )

    if(NOT LIB_CXX_STD)
        set(LIB_CXX_STD ${DEFAULT_CXX_STD})
    endif()

    if(LIB_NAMESPACE)
        set(TARGET "${LIB_NAMESPACE}::${TARGET}")
    endif()

    if(LIB_HEADER_ONLY)
        add_library(${TARGET} INTERFACE)
        set(VISIBILITY INTERFACE)
    elseif(LIB_SHARED)
        add_library(${TARGET} SHARED ${SOURCES})
        set(VISIBILITY PUBLIC)
    else()
        add_library(${TARGET} STATIC ${SOURCES})
        set(VISIBILITY PUBLIC)
    endif()

    target_include_directories(${TARGET} ${VISIBILITY}
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>)

    if(NOT LIB_HEADER_ONLY)
        target_include_directories(${TARGET} PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/src)

        set_compiler_and_linker_flags(${TARGET} OFF ${LIB_CXX_STD})

        set_target_properties(${TARGET} PROPERTIES OUTPUT_NAME ${TARGET})
        set_output_directories(${TARGET} LIBRARY)
        set_version_properties(${TARGET} "${LIB_VERSION}")
    endif()

    add_include_directories(${TARGET} PRIVATE "${LIB_INCLUDE_DIRS}")

    link_dependencies(${TARGET} INTERFACE "${LIB_INTERFACE_DEPS}")
    if(LIB_HEADER_ONLY)
        link_dependencies(${TARGET} INTERFACE "${LIB_PUBLIC_DEPS}")
        target_compile_definitions(${TARGET} INTERFACE "${LIB_COMPILE_DEFS}")
        target_compile_features(${TARGET} INTERFACE cxx_std_${LIB_CXX_STD})
    else()
        link_dependencies(${TARGET} PUBLIC "${LIB_PUBLIC_DEPS}")
        link_dependencies(${TARGET} PRIVATE "${LIB_PRIVATE_DEPS}")
        target_compile_definitions(${TARGET} PRIVATE "${LIB_COMPILE_DEFS}")
    endif()

    if(LIB_SHARED)
        set_target_properties(${TARGET} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    endif()
endfunction()

function(auto_create_library TARGET)
    cmake_parse_arguments(AUTO "" "" "EXCLUDE_PATTERNS" ${ARGN})
    file(GLOB_RECURSE SOURCES src/*.cpp src/*.c src/*.cxx src/*.cc)
    file(GLOB_RECURSE HEADERS include/*.h include/*.hpp include/*.hxx)

    foreach(pattern ${AUTO_EXCLUDE_PATTERNS})
        list(FILTER SOURCES EXCLUDE REGEX ${pattern})
        list(FILTER HEADERS EXCLUDE REGEX ${pattern})
    endforeach()

    if(NOT SOURCES AND HEADERS)
        create_library(${TARGET} "" "${HEADERS}" HEADER_ONLY ${ARGN})
    else()
        create_library(${TARGET} "${SOURCES}" "${HEADERS}" ${ARGN})
    endif()
endfunction()
