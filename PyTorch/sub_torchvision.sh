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
echo Install torchvision $1
cd
sudo apt-get -y install libjpeg-dev zlib1g-dev

# /torchvision/csrc/cpu/video_reader/FfmpegHeaders.h:4:10:
# fatal error: libavcodec/avcodec.h: No such file or directory #include <libavcodec/avcodec.h>
sudo apt-get install -y libavcodec-dev
sudo apt-get install -y libavformat-dev
sudo apt-get install -y libswscale-dev

# see below for version of torchvision to download
# TV_VERSION=v0.5.0
TV_VERSION=$1
# where 0.x.0 is the torchvision version
export BUILD_VERSION=${TV_VERSION#v}
echo TV_VERSION $TV_VERSION
echo BUILD_VERSION $BUILD_VERSION
git clone --branch $TV_VERSION https://github.com/pytorch/vision torchvision --depth 1
cd torchvision
sudo python3 setup.py install
# attempting to load torchvision from build dir will result in import error
cd ../


# export BUILD_VERSION=0.8.1
# torchvision v0.8.0a0+45f960c

# https://github.com/pytorch/vision/blob/ca6fdd6d5de3643d79667bac5dd4e2c6ecaf21bc/setup.py#L45
# export BUILD_VERSION=0.8.1
# python3 setup.py install --user
# sudo chown -R jetson /home/jetson/torchvision


# always needed for Python 2.7, not needed torchvision v0.5.0+ with Python 3.
# (not needed) pip install 'pillow<7'

# Verifying The Installation
python3 -c "import torchvision; print (torchvision.__version__)"
# 0.5.0a0+85b8fbf

cat << EOF
# Verification
import torch
print(torch.__version__)
print('CUDA available: ' + str(torch.cuda.is_available()))
print('cuDNN version: ' + str(torch.backends.cudnn.version()))
a = torch.cuda.FloatTensor(2).zero_()
print('Tensor a = ' + str(a))
b = torch.randn(2).cuda()
print('Tensor b = ' + str(b))
c = a + b
print('Tensor c = ' + str(c))

# Verification
import torchvision
print(torchvision.__version__)
EOF

