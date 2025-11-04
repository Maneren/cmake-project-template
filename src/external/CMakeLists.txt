# Add external dependencies
# Recursively add all top-level CMakeLists.txt for each library (this is to
# handle libraries with root CMakeLists.txt in a subdirectory)
file(GLOB_RECURSE EXTERNAL_CMAKE_FILES */CMakeLists.txt)
set(PROCESSED_DIRS "")
foreach(CMAKE_FILE ${EXTERNAL_CMAKE_FILES})
    get_filename_component(DIR ${CMAKE_FILE} DIRECTORY)

    # Check if this directory or a parent has already been processed
    set(SHOULD_PROCESS TRUE)
    foreach(PROCESSED_DIR ${PROCESSED_DIRS})
        # Check if current dir is subdirectory of already processed dir
        string(FIND ${DIR} ${PROCESSED_DIR} PARENT_MATCH)
        if(PARENT_MATCH EQUAL 0)
            set(SHOULD_PROCESS FALSE)
            break()
        endif()
    endforeach()

    if(SHOULD_PROCESS)
        add_subdirectory(${DIR} EXCLUDE_FROM_ALL SYSTEM)
        list(APPEND PROCESSED_DIRS ${DIR})
    endif()
endforeach()
