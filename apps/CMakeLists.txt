# Auto-discover and build all application subdirectories
file(GLOB LIB_DIRS LIST_DIRECTORIES TRUE ./*)
foreach(DIR ${LIB_DIRS})
    get_filename_component(DIR_NAME ${DIR} NAME)
    if(IS_DIRECTORY ${DIR} AND EXISTS ${DIR}/CMakeLists.txt)
        add_subdirectory(${DIR})
    endif()
endforeach()
