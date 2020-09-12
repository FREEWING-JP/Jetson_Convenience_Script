#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ ! -d ~/opencv_440 ]; then
  echo "Error No opencv_440 Directory"
  exit 0
fi


# ===
# Build OpenCV deb
cd
cd opencv_440
cd opencv
cd build

# ===
# OpenCV version
./bin/opencv_version
# 4.4.0

cpack -G DEB

ls -l OpenCV*.deb
# -rw-rw-r-- 1 jetson jetson  1585292 Sep 10 23:15 OpenCV-4.4.0-aarch64-dev.deb
# -rw-rw-r-- 1 jetson jetson 60232328 Sep 10 23:15 OpenCV-4.4.0-aarch64-libs.deb
# -rw-rw-r-- 1 jetson jetson    15992 Sep 10 23:15 OpenCV-4.4.0-aarch64-licenses.deb
# -rw-rw-r-- 1 jetson jetson     7068 Sep 10 23:15 OpenCV-4.4.0-aarch64-main.deb
# -rw-rw-r-- 1 jetson jetson  2106110 Sep 10 23:15 OpenCV-4.4.0-aarch64-python.deb
# -rw-rw-r-- 1 jetson jetson     1046 Sep 10 23:15 OpenCV-4.4.0-aarch64-scripts.deb

