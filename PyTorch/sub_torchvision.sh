#!/bin/bash

cd `dirname $0`

# ===
# ===

# chmod +x dependencies.sh
# bash ./dependencies.sh

echo "torchvision $1"

# fatal error: libavcodec/avcodec.h: No such file or directory
sudo apt-get -y install libavcodec-dev
sudo apt-get -y install libavformat-dev

# fatal error: libswscale/swscale.h: No such file or directory
sudo apt-get -y install libswscale-dev


# Install torchvision v0.5.0
cd
sudo apt-get -y install libjpeg-dev zlib1g-dev
# see below for version of torchvision to download
# TV_VERSION=v0.5.0
TV_VERSION=$1
git clone --branch $TV_VERSION https://github.com/pytorch/vision torchvision --depth 1
cd torchvision
sudo python3 setup.py install
# attempting to load torchvision from build dir will result in import error
cd ../

# always needed for Python 2.7, not needed torchvision v0.5.0+ with Python 3.
# (not needed) pip install 'pillow<7'

# Verifying The Installation
python3 -c "import torchvision; print (torchvision.__version__)"
# 0.5.0a0+85b8fbf

