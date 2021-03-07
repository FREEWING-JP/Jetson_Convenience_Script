#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


PYTORCH_VERSION=1.7.1
TORCHVISION_VERSION=0.8.2
PYTHON_VERSION=36

echo PYTORCH_VERSION=$PYTORCH_VERSION
echo TORCHVISION_VERSION=$TORCHVISION_VERSION
echo PYTHON_VERSION=$PYTHON_VERSION


gcc --version


# ===
# ===
# Pytorch version
TF_VERSION=`python3 -c "import torch; print (torch.__version__)"`
if [ $? -ne 0 ]; then
  echo "no Pytorch"
  exit 0
fi

TF_VERSION=`python3 -c "import torchvision; print (torchvision.__version__)"`
if [ $? = 0 ]; then
  echo "Already Installed torchvision"
  exit 0
fi


# torchvision v0.8.2
sudo apt-get install -y libavcodec-dev
sudo apt-get install -y libavformat-dev
sudo apt-get install -y libswscale-dev

cd
git clone --recursive --branch v$TORCHVISION_VERSION https://github.com/pytorch/vision --depth 1
cd vision


# if Jetson Nano Need export MAX_JOBS=3 to Reduce Memory usage
tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id
# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  echo Jetson Xavier NX
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  echo Jetson Nano
fi
# Allowing ninja to set a default number of workers... (overridable by setting the environment variable MAX_JOBS=N)

unset MAX_JOBS

export BUILD_VERSION=$TORCHVISION_VERSION
time sudo python3 setup.py install
# Using /usr/local/lib/python3.6/dist-packages
# Finished processing dependencies for torchvision==0.8.0a0+2f40a48

# Jetson Xavier NX
# real    4m18.352s
# user    19m39.352s
# sys     1m44.984s

cd
python3 -c "import torchvision; print(torchvision.__version__);"
# 0.8.0a0+2f40a48 (torchvision v0.8.2)

pip3 list --format=legacy | grep torch
# torch (1.7.1)
# torchvision (0.8.0a0+2f40a48)

