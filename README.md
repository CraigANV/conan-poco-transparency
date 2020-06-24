# Conan Poco Transparency Demo

This is an attempt to use Poco in a 'conan-transparent' way, i.e. allow the user to build the basic Poco md5sum example
both with and without using Conan to manage the Poco dependency in a non-intrusive way in cmake.

The idea is that the user should be able to select the Conan installation using a `USE_CONAN_PACKAGE` switch in cmake.
If this switch is off the cmake should look in the normal non-Conan locations for Poco.

The problem is that it's not clear how to link to the Poco target in a way that works both ways, the Poco targets
exported when using Conan are not the same as those from the standard non-Conan Poco package.

I have attempted several methods:


## Using the Conan `cmake_paths` & `cmake_find_package` generators & `find_package` with switched Poco target

This is the closest I can get to an ideal solution so it's presented first.

Building against Conan packages works:
```bash
mkdir build && cd build
conan install ..
cmake .. -D USE_CONAN_PACKAGE=True
cmake --build .
./md5
```

Building against libpoco-dev also works:
```bash
mkdir build && cd build
cmake ..
cmake --build .
./md5
```

However the problem with this method is that we have to link against different targets based on whether or not Conan is
switched on with `USE_CONAN_PACKAGE`:

```cmake
if(USE_CONAN_PACKAGE)
 target_link_libraries(md5 Poco::Poco)
else()
 target_link_libraries(md5 Poco::Foundation)
endif(USE_CONAN_PACKAGE)
```

This is OK for end users, but will not work for library developers who wish to export transitive targets. 


## Using the Conan `cmake` generator without targets

Building against Conan packages works:
```bash
mkdir build && cd build
conan install ..
cmake ../conan_cmake_without_targets -D USE_CONAN_PACKAGE=True
cmake --build .
./bin/md5
```

The problem with this method is that the target is linked to `CONAN_LIBS`, which is obviously not transparent.

Building against libpoco-dev does not work:
```bash
mkdir build && cd build
cmake ../conan_cmake_without_targets

    /usr/bin/ld: CMakeFiles/md5.dir/home/craig/workspace/conan-poco-transparent/main.cpp.o: in function `main':
    main.cpp:(.text+0x37): undefined reference to `Poco::MD5Engine::MD5Engine()'
    ...
```


## Using the Conan `cmake` generator with targets

Building against Conan packages works:
```bash
mkdir build && cd build
conan install ..
cmake ../conan_cmake_with_targets -D USE_CONAN_PACKAGE=True
cmake --build .
./bin/md5
```

The problem with this method is that the target is linked to `CONAN_PKG::poco`, which again is obviously not transparent.

Building against libpoco-dev does not work:
```bash
mkdir build && cd build
cmake ../conan_cmake_with_targets

    CMake Error at CMakeLists.txt:17 (add_executable):
      Target "md5" links to target "CONAN_PKG::poco" but the target was not
      found.  Perhaps a find_package() call is missing for an IMPORTED target, or
      an ALIAS target is missing?
```


## Using the Conan `cmake_paths` & `cmake_find_package` generators & find_package without Poco target

Building against Conan packages works:
```bash
mkdir build && cd build
conan install ..
cmake ../conan_paths_find_without_targets/ -D USE_CONAN_PACKAGE=True
cmake --build .
./md5
```

The problem with this method is that the target is linked to `Poco_INCLUDE_DIRS` and `Poco_LIBS` which are NOT provided
by apt installed libpoco-dev cmake. Even if this were not the case this method is not ideal for exporting a Lib target
with transitive targets, i.e. the 'modern' cmake way

Building against libpoco-dev does not work:
```bash
mkdir build && cd build
cmake ../conan_paths_find_without_targets/

    /usr/bin/ld: CMakeFiles/md5.dir/home/craig/workspace/conan-poco-transparent/main.cpp.o: in function `main':
    main.cpp:(.text+0x37): undefined reference to `Poco::MD5Engine::MD5Engine()'
```


## Using the Conan `cmake_paths` & `cmake_find_package` generators & find_package with Poco target

Building against Conan packages works:
```bash
mkdir build && cd build
conan install ..
cmake ../conan_paths_find_with_targets/ -D USE_CONAN_PACKAGE=True
cmake --build .
./md5
```

The problem with this method is that we have to link against the `Poco::Poco` target, which is NOT provided by apt
installed libpoco-dev cmake.

Building against libpoco-dev does not work:
```bash
mkdir build && cd build
cmake ../conan_paths_find_with_targets/

    CMake Error at CMakeLists.txt:18 (add_executable):
      Target "md5" links to target "Poco::Poco" but the target was not found.
      Perhaps a find_package() call is missing for an IMPORTED target, or an
      ALIAS target is missing?
```


## Using the build script to automate checks

Note: only the default cmake (i.e. the root one will work)

```bash
./build.sh <optional dir, e.g. conan_paths_find_with_targets>
```
