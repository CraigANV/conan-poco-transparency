cmake_minimum_required(VERSION 3.16)
project(MD5Encrypter)

set(VERBOSE ON)
set(CMAKE_FIND_DEBUG_MODE ON)

add_definitions("-std=c++11")

#
## Using 'cmake_paths' & 'cmake_find_package' generators & find_package with switched Poco target
#
if(USE_CONAN_PACKAGE)
 include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
endif(USE_CONAN_PACKAGE)

find_package(Poco REQUIRED COMPONENTS Foundation)

add_executable(demo ../main.cpp)

if(USE_CONAN_PACKAGE)
 target_link_libraries(demo Poco::Poco)
else()
 target_link_libraries(demo Poco::Foundation)
endif(USE_CONAN_PACKAGE)
