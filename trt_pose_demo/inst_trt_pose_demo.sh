#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/trt_pose_demo ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ModuleNotFoundError: No module named 'trt_pose'
pip3 list --format=columns | grep trt-pose
if [ $? -ne 0 ]; then
  echo "no trt-pose"
  exit 0
fi


cd
git clone https://github.com/MACNICA-CLAVIS-NV/trt_pose_demo
cd trt_pose_demo


# ====
# Model
# resnet18_baseline_att_224x224_A
# https://drive.google.com/open?id=1XYDdCUdiF2xxx4rznmLb62SdOUZuoNbd
FILE_ID=1XYDdCUdiF2xxx4rznmLb62SdOUZuoNbd
FILE_NAME=resnet18_baseline_att_224x224_A_epoch_249.pth
wget "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O ${FILE_NAME}

# human_pose.json
wget https://raw.githubusercontent.com/NVIDIA-AI-IOT/trt_pose/master/tasks/human_pose/human_pose.json


echo "python3 trt_pose_app.py --nodrop test.mov"

