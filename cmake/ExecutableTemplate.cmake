include(${CMAKE_CURRENT_LIST_DIR}/CommonUtils.cmake)

function(create_executable TARGET SOURCES)
    cmake_parse_arguments(EXE
        "CONSOLE;GUI;TEST"
        "VERSION;OUTPUT_NAME;CXX_STD"
        "PRIVATE_DEPS;COMPILE_DEFS;INCLUDE_DIRS"
        ${ARGN}
    )

    if(SOURCES)
        if (EXE_TEST)
            add_executable(${TARGET} EXCLUDE_FROM_ALL "${SOURCES}")
        else()
            add_executable(${TARGET} "${SOURCES}")
        endif()
    else()
        message(FATAL_ERROR "Executable ${TARGET} has no sources")
    endif()

    add_include_directories(${TARGET} PRIVATE "${EXE_INCLUDE_DIRS}")
    set_compiler_and_linker_flags(${TARGET} ${EXE_TEST} ${EXE_CXX_STD})
    target_compile_definitions(${TARGET} PRIVATE "${EXE_COMPILE_DEFS}")
    link_dependencies(${TARGET} PRIVATE "${EXE_PRIVATE_DEPS}")

    if(EXE_TEST)
        set_output_directories(${TARGET} TEST)
    else()
        set_output_directories(${TARGET} EXECUTABLE)
    endif()

    if(EXE_OUTPUT_NAME)
        set_target_properties(${TARGET} PROPERTIES OUTPUT_NAME ${EXE_OUTPUT_NAME})
    endif()

    set_version_properties(${TARGET} "${EXE_VERSION}")

    if(WIN32)
        if(EXE_CONSOLE)
            set_target_properties(${TARGET} PROPERTIES WIN32_EXECUTABLE FALSE)
        elseif(EXE_GUI)
            set_target_properties(${TARGET} PROPERTIES WIN32_EXECUTABLE TRUE)
        endif()
    endif()
endfunction()

function(auto_create_executable TARGET)
    file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS src/*.cpp src/*.c src/*.cxx src/*.cc src/*.h src/*.hpp src/*.hxx)
    create_executable(${TARGET} "${SOURCES}" ${ARGN})
endfunction()
