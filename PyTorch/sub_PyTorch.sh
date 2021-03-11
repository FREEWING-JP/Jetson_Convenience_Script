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


# Install numpy
echo "# ==="
echo "# Install numpy"
sudo pip3 install six==1.15.0
# Successfully installed six-1.15.0

# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
# uff 0.6.9 requires protobuf>=3.3.0, but you have protobuf 3.0.0 which is incompatible.
sudo pip3 install protobuf==3.15.5

export OPENBLAS_CORETYPE=ARMV8
NUMPY_VER=1.19.5
echo sudo pip3 install -U numpy==$NUMPY_VER
sudo pip3 install -U numpy==$NUMPY_VER

sudo pip3 install uff==0.6.9


sudo pip3 install $WHL_NAME

# Verifying The Installation
python3 -c "import torch; print (torch.__version__)"
# 1.4.0

cd $SCRIPT_DIR

# Install torchvision v0.5.0
chmod +x sub_torchvision.sh
bash ./sub_torchvision.sh $TORCHVISION_VERSION

