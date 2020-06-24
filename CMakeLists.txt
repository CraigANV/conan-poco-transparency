cmake_minimum_required(VERSION 3.16)
project(MD5Encrypter)

set(VERBOSE ON)
set(CMAKE_FIND_DEBUG_MODE ON)

add_definitions("-std=c++11")

#
## Using apt installed libpoco-dev, not conan
## Linking against Poco::Foundation, as we should be
#
find_package(Poco REQUIRED COMPONENTS Foundation)

add_executable(md5 ../main.cpp)
target_link_libraries(md5 Poco::Foundation)
