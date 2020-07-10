#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/libjpeg-turbo-2.0.5 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# libjpeg-turbo 2.0.5 ae87a95 Jun 24 2020
cd
wget -O libjpeg-turbo_205.zip https://github.com/libjpeg-turbo/libjpeg-turbo/archive/2.0.5.zip
unzip libjpeg-turbo_205.zip

cd
cd libjpeg-turbo-2.0.5

mkdir build
cd build

# libjpeg v8 WITH_JPEG8=1
cmake \
  -D CMAKE_BUILD_TYPE=Release \
  -D WITH_JPEG8=1 \
  ..

# Build libjpeg-turbo
time make -j$(nproc)
# about 3 minute

make test

# Install libjpeg-turbo
sudo make install

ls -l /opt/libjpeg-turbo/
ls -l /opt/libjpeg-turbo/lib64/libturbojpeg.*

echo "-D JPEG_INCLUDE_DIR=/opt/libjpeg-turbo/include"
echo "-D JPEG_LIBRARY=/opt/libjpeg-turbo/lib64/libturbojpeg.a"

# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

