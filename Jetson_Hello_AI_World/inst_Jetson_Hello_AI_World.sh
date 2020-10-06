#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/jetson-inference ]; then
  echo "Already Exists Directory"
  exit 0
fi


# Building the Project from Source
# https://github.com/dusty-nv/jetson-inference/blob/master/docs/building-repo.md

# git and cmake
sudo apt-get update
sudo apt-get install -y git cmake
sudo apt-get install -y tree

# Python Development Packages
sudo apt-get install -y libpython3-dev python3-numpy

# Cloning the Repo
cd
git clone https://github.com/dusty-nv/jetson-inference --depth 1
cd jetson-inference
# or --recursive
git submodule update --init

# Configuring with CMake
mkdir build
cd build
cmake ../

# Compiling the Project
make -j$(nproc)
sudo make install
sudo ldconfig

tree ./aarch64


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

