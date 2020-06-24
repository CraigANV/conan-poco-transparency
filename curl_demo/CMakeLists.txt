cmake_minimum_required(VERSION 3.16)
project(CurlDemo)

set(VERBOSE ON)
set(CMAKE_FIND_DEBUG_MODE ON)

if(USE_CONAN_PACKAGE)
    include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
endif(USE_CONAN_PACKAGE)

find_package(CURL REQUIRED)

add_executable(demo curldemo.cpp)

if(USE_CONAN_PACKAGE)
    target_link_libraries(demo CURL::CURL)
else()
    target_link_libraries(demo CURL::libcurl)
endif(USE_CONAN_PACKAGE)
