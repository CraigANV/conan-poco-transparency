cmake_minimum_required(VERSION 3.16)
project(MD5Encrypter)

set(VERBOSE ON)
set(CMAKE_FIND_DEBUG_MODE ON)

add_definitions("-std=c++11")

#
## Using 'cmake_paths' & 'cmake_find_package' generators & find_package with Poco target
#
if(USE_CONAN_PACKAGE)
 include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
endif(USE_CONAN_PACKAGE)

find_package(Poco REQUIRED COMPONENTS Foundation)

add_executable(md5 ../main.cpp)
target_link_libraries(md5 Poco::Poco)
