#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
# Pytorch version
TF_VERSION=`python3 -c "import torch; print (torch.__version__)"`
if [ $? = 0 ]; then
  echo "Already Installed Pytorch"
  exit 0
fi

TF_VERSION=`python3 -c "import torchvision; print (torchvision.__version__)"`
if [ $? = 0 ]; then
  echo "Already Installed torchvision"
  exit 0
fi


cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 6\."
# R32 (release), REVISION: 6.x
if [ $? = 0 ]; then
  echo "JetPack 4.6"

  PYTORCH_VERSION=v1.9.0
  TORCHVISION_VERSION=v0.10.0
  WHL_URL=https://nvidia.box.com/shared/static/h1z9sw4bb1ybi0rm3tu8qdj8hs05ljbm.whl
  WHL_NAME=torch-1.9.0-cp36-cp36m-linux_aarch64.whl

  chmod +x sub_PyTorch.sh
  bash ./sub_PyTorch.sh $PYTORCH_VERSION $TORCHVISION_VERSION $WHL_URL $WHL_NAME

  cd $SCRIPT_DIR
  if [ -e ../bell.sh ]; then
    chmod +x ../bell.sh
    bash ../bell.sh
  fi

  exit 0
fi

cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 5\."
# R32 (release), REVISION: 5.0, GCID: 25531747, BOARD: t186ref, EABI: aarch64, DATE: Fri Jan 15 23:21:05 UTC 2021
if [ $? = 0 ]; then
  echo "JetPack 4.5"

  PYTORCH_VERSION=v1.9.0
  TORCHVISION_VERSION=v0.10.0
  WHL_URL=https://nvidia.box.com/shared/static/h1z9sw4bb1ybi0rm3tu8qdj8hs05ljbm.whl
  WHL_NAME=torch-1.9.0-cp36-cp36m-linux_aarch64.whl

  chmod +x sub_PyTorch.sh
  bash ./sub_PyTorch.sh $PYTORCH_VERSION $TORCHVISION_VERSION $WHL_URL $WHL_NAME

  cd $SCRIPT_DIR
  if [ -e ../bell.sh ]; then
    chmod +x ../bell.sh
    bash ../bell.sh
  fi

  exit 0
fi

echo "No Support JetPack Version Error"

