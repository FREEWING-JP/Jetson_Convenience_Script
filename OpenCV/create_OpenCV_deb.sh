#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ ! -d ~/opencv_451 ]; then
  echo "Error No opencv_451 Directory"
  exit 0
fi


# ===
# Build OpenCV deb
cd
cd opencv_451
cd opencv
cd build

# ===
# OpenCV version
./bin/opencv_version
# 4.5.1

cpack -G DEB

ls -l OpenCV*.deb
# -rw-rw-r-- 1 jetson jetson  1644526 Jan 30 03:07 OpenCV-4.5.1-aarch64-dev.deb
# -rw-rw-r-- 1 jetson jetson 56169128 Jan 30 03:07 OpenCV-4.5.1-aarch64-libs.deb
# -rw-rw-r-- 1 jetson jetson    16738 Jan 30 03:07 OpenCV-4.5.1-aarch64-licenses.deb
# -rw-rw-r-- 1 jetson jetson     6862 Jan 30 03:07 OpenCV-4.5.1-aarch64-main.deb
# -rw-rw-r-- 1 jetson jetson  2201378 Jan 30 03:07 OpenCV-4.5.1-aarch64-python.deb
# -rw-rw-r-- 1 jetson jetson     1036 Jan 30 03:07 OpenCV-4.5.1-aarch64-scripts.deb

