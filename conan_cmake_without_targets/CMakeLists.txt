cmake_minimum_required(VERSION 3.16)
project(MD5Encrypter)

set(VERBOSE ON)

add_definitions("-std=c++11")

#
## Using 'cmake' generator without TARGETS
## 'CONAN_LIBS' is obviously not transparent
#
if(USE_CONAN_PACKAGE)
 include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
 conan_basic_setup()
endif(USE_CONAN_PACKAGE)

add_executable(md5 ../main.cpp)
target_link_libraries(md5 ${CONAN_LIBS})
