#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ./x264 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# libx264 x264 H.264 MPEG-4 AVC
# Unknown encoder 'libx264'
git clone https://code.videolan.org/videolan/x264.git --depth 1
cd x264
./configure --enable-pic --enable-shared
# time make -j4
time make -j$(nproc)
# real    2m3.284s
# user    4m9.476s
# sys     0m13.236s

sudo make install

