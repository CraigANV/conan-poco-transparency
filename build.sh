#!/usr/bin/env bash

set -ex

exec > >(tee "build.log") 2>&1
date

function mkcd()
{
  rm -rf "$1" && mkdir "$1" && pushd "$1"
}

# Make the script agnostic to where its called from
pushd "$(dirname "$(readlink -f "$0")")" > /dev/null

CMAKE_DIR="../"$1

set -u

readonly APT_PACKAGES="libpoco-dev"

# Build with Conan installed packages
mkcd build
conan install ..
cmake $CMAKE_DIR -D USE_CONAN_PACKAGE=True
cmake --build . --parallel 2
popd

# Build without Conan packages
mkcd build2
cmake $CMAKE_DIR
cmake --build . --parallel 2
popd

printf "\n\n Building with and without Conan packages successfully\n"
