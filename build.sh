#!/usr/bin/env bash

set -ex

exec > >(tee "build.log") 2>&1
date

function mkcd()
{
  rm -rf "$1" && mkdir "$1" && pushd "$1"
}

function revert_conan_uninstall()
{
  # revert simulated uninstall
  if [[ -d ~/.conan/data.bk ]]; then
    mv ~/.conan/data.bk ~/.conan/data
  fi
}

function conan_uninstall()
{
  # simulate uninstall to save time
  if [[ -d ~/.conan/data ]]; then
    mv ~/.conan/data ~/.conan/data.bk
  fi
}

# Make the script agnostic to where its called from
pushd "$(dirname "$(readlink -f "$0")")" > /dev/null

CMAKE_DIR="../"$1

set -u

readonly APT_PACKAGES="libpoco-dev"
revert_conan_uninstall

# Build with Conan installed packages
sudo apt -y purge $APT_PACKAGES
sudo apt -y auto-remove
mkcd build
conan install ..
cmake $CMAKE_DIR -D USE_CONAN_PACKAGE=True
cmake --build . --parallel 2
popd

# Build without Conan packages
sudo apt install -y $APT_PACKAGES
conan_uninstall

mkcd build2
cmake $CMAKE_DIR
cmake --build . --parallel 2

revert_conan_uninstall
