cmake_minimum_required(VERSION 3.16)
project(MD5Encrypter)

set(VERBOSE ON)
set(CMAKE_FIND_DEBUG_MODE ON)

add_definitions("-std=c++11")

#
## Using 'cmake_paths' & 'cmake_find_package' generators & find_package without Poco target
## This is not ideal for exporting a Lib target with transitive targets
## Poco_INCLUDE_DIRS and Poco_LIBS are NOT provided by apt installed libpoco-dev cmake
#
if(USE_CONAN_PACKAGE)
 include(${CMAKE_BINARY_DIR}/conan_paths.cmake)
endif(USE_CONAN_PACKAGE)

variable_watch(Poco_INCLUDE_DIRS)
variable_watch(Poco_LIBS)

find_package(Poco REQUIRED COMPONENTS Foundation)

add_executable(md5 ../main.cpp)
target_include_directories(md5 PUBLIC ${Poco_INCLUDE_DIRS})
target_link_libraries(md5 ${Poco_LIBS})
