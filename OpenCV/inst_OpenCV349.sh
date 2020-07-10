#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/opencv_34 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
echo "OpenCV 3.4.9"
# OpenCV3 OpenCV 3.4.9 21 Dec 2019 3.4.9 64e6cf9
chmod +x sub_OpenCV3.sh
bash ./sub_OpenCV3.sh 3.4.9


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

