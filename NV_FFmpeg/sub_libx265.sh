#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ./x265 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# libx265 x265 HEVC Encoder
# ubuntu packages:
# sudo apt-get install mercurial cmake cmake-curses-gui build-essential yasm
sudo apt-get -y install mercurial build-essential yasm nasm

# Note: if the packaged yasm is older than 1.2, you must download yasm (1.3 recommended) and build it
# If you are compiling off the default branch after release of v2.6, you must have nasm (2.13 or newer) installed and added to your path

# Release_3.4 2020‑05‑30
# hg clone https://bitbucket.org/multicoreware/x265 -r 1 -b Release_3.4

# Release_3.5
git clone https://bitbucket.org/multicoreware/x265_git.git x265 -b Release_3.5 --depth 1
cd x265/build/linux
./make-Makefiles.bash

# time make -j4
time make -j$(nproc)
# real    1m30.326s
# user    3m42.940s
# sys     0m7.984s

sudo make install

