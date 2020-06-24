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

# TODO: double-colons is a common pattern used to namespace IMPORTED targets and ALIAS targets, it's not clear how
# to create workaround targets for namespaced targets...
#if(USE_CONAN_PACKAGE)
# add_library(PocoFoundationWorkaround INTERFACE)
# target_include_directories(PocoFoundationWorkaround INTERFACE ${Poco_INCLUDE_DIRS})
# target_link_libraries(PocoFoundationWorkaround INTERFACE PocoFoundation)
# add_library(Poco::Foundation ALIAS PocoFoundationWorkaround)
#endif(USE_CONAN_PACKAGE)

if(USE_CONAN_PACKAGE)
 add_library(PocoWorkaround INTERFACE)
 target_link_libraries(PocoWorkaround INTERFACE Poco::Poco)
 add_library(Poco::Foundation ALIAS PocoWorkaround)
endif(USE_CONAN_PACKAGE)

add_executable(demo ../main.cpp)
target_link_libraries(demo Poco::Foundation)
