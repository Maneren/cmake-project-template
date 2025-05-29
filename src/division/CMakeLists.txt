cmake_minimum_required(VERSION 3.10)
project(division C CXX)

file(GLOB_RECURSE SOURCE_FILES ./*.cpp ./*.h)

add_library(division SHARED STATIC ${SOURCE_FILES})

install(TARGETS division DESTINATION ${DIVISIBLE_INSTALL_LIB_DIR})
install(FILES division.h DESTINATION ${DIVISIBLE_INSTALL_INCLUDE_DIR})
