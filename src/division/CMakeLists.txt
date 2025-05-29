cmake_minimum_required(VERSION 3.10)
set(LIBRARY division)
project(${LIBRARY} LANGUAGES CXX)

file(GLOB_RECURSE SOURCE_FILES *.cpp *.h)

add_library(${LIBRARY} SHARED STATIC ${SOURCE_FILES})

install(TARGETS ${LIBRARY} DESTINATION ${PROJECT_LIB_DIR})

include_directories(../include/)
