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


# L4T 32.4.2 = JetPack 4.4
cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 4."
# R32 (release), REVISION: 4.2, GCID: 20074772, BOARD: t186ref, EABI: aarch64, DATE: Thu Apr  9 01:26:40 UTC 2020
if [ $? = 0 ]; then
  # L4T 32.4.2 = JetPack 4.4
  echo "JetPack 4.4"

  PYTORCH_VERSION=v1.5.0
  TORCHVISION_VERSION=v0.6.0
  WHL_URL=https://nvidia.box.com/shared/static/3ibazbiwtkl181n95n9em3wtrca7tdzp.whl
  WHL_NAME=torch-1.5.0-cp36-cp36m-linux_aarch64.whl

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

