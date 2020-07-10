#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/CMake ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# CMake version
cmake --version | grep "cmake version 3.10"
if [ $? -ne 0 ]; then
  echo "Already Exists New version"
  exit 0
fi


# ===
# Build CMake

# sudo apt-get update
sudo apt-get update

# Do not Install cmake
sudo apt-get -y install git

# user@user-desktop:~$ cmake --version
# cmake version 3.10.2
# apt-get install cmake OpenPose Error
# CMake Error: The following variables are used in this project, but they are set to NOTFOUND.

# Build Newest cmake for Build OpenPose
sudo apt -y remove cmake cmake-data

# https supported cmake when Build OpenCV 4.1.0 https Error
# cmake_download Protocol "https" not supported or disabled in libcurl
# Download failed: 1;"Unsupported protocol"
# boostdesc_bgm.i: No such file or directory
# sudo apt-get -y install libcurl-devel
# https://packages.ubuntu.com/bionic/libcurl-dev
sudo apt-get -y install libcurl4-openssl-dev

cd
git clone https://github.com/Kitware/CMake.git --depth 1 -b v3.17.3
cd CMake

# --system-curl https support cmake
./bootstrap --system-curl

# make -j4
time make -j$(nproc)

./bin/cmake --version
# cmake version 3.17.3
# CMake suite maintained and supported by Kitware (kitware.com/cmake).

# Install CMake
sudo make install

# cmake version
cmake --version

# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

