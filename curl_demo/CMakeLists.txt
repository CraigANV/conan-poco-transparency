cmake_minimum_required(VERSION 3.16)
project(CurlDemo)

set(VERBOSE ON)
set(CMAKE_FIND_DEBUG_MODE ON)

if(USE_CONAN_PACKAGE)
    include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
endif(USE_CONAN_PACKAGE)

find_package(CURL REQUIRED)

if(USE_CONAN_PACKAGE)
    add_library(CurlWorkaround INTERFACE)
    target_link_libraries(CurlWorkaround INTERFACE CURL::CURL)
    add_library(CURL::libcurl ALIAS CurlWorkaround)
endif(USE_CONAN_PACKAGE)

add_executable(demo curldemo.cpp)
target_link_libraries(demo CURL::libcurl)
