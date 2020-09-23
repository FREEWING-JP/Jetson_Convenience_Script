#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ ! -d ~/CMake ]; then
  echo "Error No CMake Directory"
  exit 0
fi


# ===
# CMake version
cmake --version


# ===
# Build CMake deb
cd
cd CMake

# cpack -G DEB
# CMake Error at /home/jetson/CMake/cmake_install.cmake:135 (file):
#   file failed to open for writing (Permission denied):
#     /home/jetson/CMake/install_manifest.txt

sudo chmod 766 install_manifest.txt

cpack -G DEB

ls -l cmake-*-Linux-aarch64.deb

