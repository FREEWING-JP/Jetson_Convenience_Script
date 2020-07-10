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
# FFmpeg GPU HW-Acceleration Support
cd
cd nvffmpeg
# Download and install ffnvcodec:
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers && sudo make install && cd -


# Download the latest FFmpeg or libav source code
cd
cd nvffmpeg
git clone https://github.com/libav/libav --depth 1

# Build libav
cd libav

./configure --enable-nvenc
time make -j$(nproc)


# Download the latest FFmpeg or libav source code
cd
cd nvffmpeg
git clone https://git.ffmpeg.org/ffmpeg.git --depth 1

cd ffmpeg

# ./configure --enable-cuda-sdk --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64
# WARNING: Option --enable-cuda-sdk is deprecated. Use --enable-cuda-nvcc instead.

# ./configure --enable-cuda-nvcc --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64
# --enable-gpl --enable-shared --enable-libx264 --enable-libx265
./configure --enable-cuda-nvcc --enable-cuvid --enable-nvenc --enable-nonfree --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-gpl --enable-shared --enable-libx264 --enable-libx265


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

