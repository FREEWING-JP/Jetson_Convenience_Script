#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


sudo apt update

# clang == clang-6
# sudo apt install -y clang
# sudo apt install -y clang-6
# E: Unable to locate package clang-6

# sudo apt install -y clang-7
# sudo apt install -y clang-8
# sudo apt install -y clang-9
sudo apt install -y clang-10

# sudo apt install -y clang-11
# E: Unable to locate package clang-11

clang-10 --version
clang++-10 --version
# clang version 10.0.0-4ubuntu1~18.04.2
# Target: aarch64-unknown-linux-gnu
# Thread model: posix
# InstalledDir: /usr/bin

