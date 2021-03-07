#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


sudo apt update
sudo apt install -y gcc-8 g++-8
# sudo apt install -y gcc-9 g++-9
# E: Unable to locate package gcc-9

# update-alternatives: error: no alternatives for gcc
# update-alternatives set default gcc-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 7
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 7
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 8

gcc --version
g++ --version

