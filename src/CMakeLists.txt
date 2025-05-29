cmake_minimum_required(VERSION 3.10)
set(EXECUTABLE divider)
project(${EXECUTABLE} LANGUAGES CXX)

file(GLOB DIRS LIST_DIRECTORIES TRUE ./*)
foreach(DIR ${DIRS})
  if(EXISTS ${DIR}/CMakeLists.txt)
    add_subdirectory(${DIR})
  endif()
endforeach()

file(GLOB SOURCE_FILES *.cpp)

add_executable(${EXECUTABLE} ${SOURCE_FILES})
target_link_libraries(${EXECUTABLE} division)
install(TARGETS ${EXECUTABLE} DESTINATION ${PROJECT_BIN_DIR})

file(GLOB INCLUDE_DIRS LIST_DIRECTORIES TRUE include/*)
install(DIRECTORY ${INCLUDE_DIRS} DESTINATION ${PROJECT_INCLUDE_DIR})

include_directories(include)
