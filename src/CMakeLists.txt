# Handle external dependencies first
set(EXPECTED_BUILD_TESTS OFF)
set(EXPECTED_BUILD_PACKAGE OFF)

# Add external dependencies
add_subdirectory(external)

# Auto-discover and build all library subdirectories
file(GLOB LIB_DIRS LIST_DIRECTORIES TRUE ./*)
foreach(DIR ${LIB_DIRS})
    get_filename_component(DIR_NAME ${DIR} NAME)
    if(IS_DIRECTORY ${DIR} AND EXISTS ${DIR}/CMakeLists.txt AND NOT DIR_NAME STREQUAL "external")
        add_subdirectory(${DIR})
    endif()
endforeach()

# Install headers
file(GLOB INCLUDE_DIRS LIST_DIRECTORIES TRUE include/*)
if(INCLUDE_DIRS)
    install(DIRECTORY ${INCLUDE_DIRS} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endif()
