#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
cd
mkdir nvffmpeg


# ===
cd
cd nvffmpeg
cp $SCRIPT_DIR/sub_libx264.sh .
cp $SCRIPT_DIR/sub_libx265.sh .

# ===
# libx264 x264 H.264 MPEG-4 AVC
cd
cd nvffmpeg
chmod +x ./sub_libx264.sh
bash ./sub_libx264.sh


# ===
# libx265 x265 HEVC Encoder
cd
cd nvffmpeg
chmod +x ./sub_libx265.sh
bash ./sub_libx265.sh


# ===
pkg-config --list-all | grep x26


# ===
# https://github.com/jocover/jetson-ffmpeg
# L4T Multimedia API for ffmpeg jetson-ffmpeg

# 1.build and install library
cd
cd nvffmpeg
# Latest commit 4ba259a Jun 22, 2020
git clone https://github.com/jocover/jetson-ffmpeg.git --depth 1
cd jetson-ffmpeg
mkdir build
cd build
cmake .. -D CMAKE_BUILD_TYPE=Release

# time make -j4
time make -j$(nproc)

sudo make install
sudo ldconfig


# ===
# 2.patch ffmpeg and build
cd
cd nvffmpeg

# FFmpeg 4.2 release/4.2
git clone git://source.ffmpeg.org/ffmpeg.git -b release/4.2 --depth=1

cd ffmpeg
wget https://github.com/jocover/jetson-ffmpeg/raw/master/ffmpeg_nvmpi.patch
git apply ffmpeg_nvmpi.patch
# ./configure --enable-nvmpi --enable-nonfree

# ./configure --enable-nvmpi --enable-nonfree --enable-gpl --enable-shared --enable-libx264 --enable-libx265
# 2020/09
# ffmpeg --enable-libx265
# ERROR: x265 not found using pkg-config
./configure --enable-nvmpi --enable-nonfree --enable-gpl --enable-shared --enable-libx264


# time make -j4
time make -j$(nproc)

ls -l ffmpeg

sudo make install

# sudo find / -name libavdevice.so.58

sudo ldconfig

./ffmpeg


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

