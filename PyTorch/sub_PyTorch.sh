#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
PYTORCH_VERSION=$1
TORCHVISION_VERSION=$2
WHL_URL=$3
WHL_NAME=$4

# chmod +x dependencies.sh
# bash ./dependencies.sh

echo "PyTorch $PYTORCH_VERSION - torchvision $TORCHVISION_VERSION"

# Install PyTorch
# Python 3.6 PyTorch 1.4.0
wget $WHL_URL -O $WHL_NAME
sudo apt-get -y install python3-pip libopenblas-base libopenmpi-dev
sudo pip3 install Cython
# Successfully installed Cython-0.29.20

sudo pip3 install numpy $WHL_NAME

# Verifying The Installation
python3 -c "import torch; print (torch.__version__)"
# 1.4.0

cd $SCRIPT_DIR

# Install torchvision v0.5.0
chmod +x sub_torchvision.sh
bash ./sub_torchvision.sh $TORCHVISION_VERSION

