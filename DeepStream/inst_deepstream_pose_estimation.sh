#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
# DeepStream Human Pose Estimation

echo $DEEPSTREAM_DIR
if [ "$DEEPSTREAM_DIR" = "" ]; then
  DEEPSTREAM_DIR=/opt/nvidia/deepstream/deepstream
  ls -l $DEEPSTREAM_DIR
  if [ $? -ne  0 ]; then
    echo "no NVIDIA DeepStream SDK"
    exit 0
  fi
fi


ls -l $DEEPSTREAM_DIR/sources/apps/sample_apps
cd $DEEPSTREAM_DIR/sources/apps/sample_apps

sudo chmod 777 .
git clone https://github.com/NVIDIA-AI-IOT/deepstream_pose_estimation --depth 1
cd deepstream_pose_estimation

#  fatal error: gst/gst.h: No such file or directory
pkg-config --cflags gstreamer-1.0

# Package json-glib-1.0 was not found in the pkg-config search path.
# Perhaps you should add the directory containing `json-glib-1.0.pc'
# to the PKG_CONFIG_PATH environment variable
# No package 'json-glib-1.0' found
sudo apt-get install libjson-glib-dev


# NVIDIA DeepStream SDK 5.1 patch
# post_process.cpp:12:10: fatal error: gstnvdsmeta.h: No such file or directory
#  #include "gstnvdsmeta.h"
ls -l $DEEPSTREAM_DIR-5.1
if [ $? -eq 0 ]; then
  echo "NVIDIA DeepStream SDK 5.1 patch"
  sed -i 's/^NVDS_VERSION:=5.0/NVDS_VERSION:=5.1/' Makefile
fi


# Jetson Nano patch
# deepstream_pose_estimation_config.txt
# Change workspace-size=3000 to 2000
tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id
# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  sed -i 's/^workspace-size=3000/workspace-size=2000/' deepstream_pose_estimation_config.txt
fi

make -j$(nproc)

which ./deepstream-pose-estimation-app
if [ $? -ne 0 ]; then
  echo "Build Error deepstream-pose-estimation-app"
  exit 0
fi

./deepstream-pose-estimation-app
# Usage: ./deepstream-pose-estimation-app <filename> <output-path>

ls -l ../../../../samples/streams/

# H264 Convert OK
sudo ./deepstream-pose-estimation-app ../../../../samples/streams/sample_720p.h264 ./720p_
ls -l *.mp4
# -rw-r--r-- 1 root   root   24177597 Feb 27 08:04 720p_Pose_Estimation.mp4


cat << EOS
# Stuck MP4 format NG
# Stuck NvMMLiteBlockCreate : Block : BlockType = 261
sudo ./deepstream-pose-estimation-app hoge.mp4 ./

# Convert MP4 to h264 (libx264) using FFmpeg OK
# Stream #0:0 -> #0:0 (h264 (native) -> h264 (libx264))
# ffmpeg -i ./hoge.mp4 -vcodec libx264 hoge.h264
ffmpeg -i ./hoge.mp4 hoge.h264

# Convert MP4 to h264 OK
sudo ./deepstream-pose-estimation-app hoge.h264 ./hoge_
ls -l *.mp4
# -rw-r--r-- 1 root   root   154019896 Feb 27 08:30 hoge_Pose_Estimation.mp4
EOS

