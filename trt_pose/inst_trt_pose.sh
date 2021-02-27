#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/trt_pose ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# pip3
# which pip3
# if [ $? -eq 0 ]; then
#   sudo apt install python3-pip
# fi

# pip3 -V
# pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)


# ===
# ===
# Pytorch version
TF_VERSION=`python3 -c "import torch; print (torch.__version__)"`
if [ $? -ne 0 ]; then
  echo "no Pytorch"
  exit 0
fi

TF_VERSION=`python3 -c "import torchvision; print (torchvision.__version__)"`
if [ $? -ne 0 ]; then
  echo "no torchvision"
  exit 0
fi


# ===
# ===
# https://github.com/NVIDIA-AI-IOT/trt_pose

# ====
# Step 1 - Install Dependencies
# Install PyTorch and Torchvision. To do this on NVIDIA Jetson, we recommend following this guide

# ====
# 1-1
# Pytorch v1.7.0 / torchvision v0.8.1 / Python 3.6
# cd
# bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_7_Python3.sh


# ====
# 1-2
# Install torch2trt
cd
mkdir trt_pose

cd
cd trt_pose
git clone https://github.com/NVIDIA-AI-IOT/torch2trt --depth 1
cd torch2trt
sudo python3 setup.py install --plugins


# ====
# 1-3
# Install other miscellaneous packages
#     from setuptools import setup, find_packages, Extension
#     RuntimeError: Python version >= 3.7 required.
#     BUILDING MATPLOTLIB
#       matplotlib: yes [3.3.4]
#           python: yes [3.6.9 (default, Oct  8 2020, 12:12:24)  [GCC 8.4.0]]
# numpy 1.20.0 Released: Jan 31, 2021, Requires: Python >=3.7
# numpy 1.19.5 Released: Jan  6, 2021, Requires: Python >=3.6
# sudo pip3 install numpy==1.19.5
# sudo pip3 install numpy==1.16.4

sudo pip3 install tqdm cython pycocotools
sudo apt-get install -y python3-matplotlib
cd ..


# Traceback (most recent call last):
#   File "live_demo.py", line 148, in <module>
#     from jetcam.usb_camera import USBCamera
# ModuleNotFoundError: No module named 'jetcam'
# https://github.com/NVIDIA-AI-IOT/jetcam
cd
cd trt_pose
git clone https://github.com/NVIDIA-AI-IOT/jetcam --depth 1
cd jetcam
sudo python3 setup.py install
cd ..
# sudo reboot
# gst-launch-1.0 nvarguscamerasrc ! nvoverlaysink


# ====
# Check OpenCV GStreamer
python3 -c "import cv2; print(cv2.getBuildInformation())"
python3 -c "import cv2; print(cv2.getBuildInformation())" | grep -E "OpenCV|ver |Version|GStreamer"
# General configuration for OpenCV 4.1.1
# Version control:               4.1.1-2-gd5a58aa75
# GStreamer:                   YES (1.14.5)


# [ WARN:0] global /home/nvidia/host/build_opencv/nv_opencv/modules/videoio/src/cap_gstreamer.cpp (1757) handleMessage OpenCV | GStreamer warning: Embedded video playback halted; module v4l2src0 reported: Internal data stream error.
# [ WARN:0] global /home/nvidia/host/build_opencv/nv_opencv/modules/videoio/src/cap_gstreamer.cpp (886) open OpenCV | GStreamer warning: unable to start pipeline
# [ WARN:0] global /home/nvidia/host/build_opencv/nv_opencv/modules/videoio/src/cap_gstreamer.cpp (480) isPipelinePlaying OpenCV | GStreamer warning: GStreamer: pipeline have not been created
# Traceback (most recent call last):
#   File "/usr/local/lib/python3.6/dist-packages/jetcam-0.0.0-py3.6.egg/jetcam/usb_camera.py", line 24, in __init__
# RuntimeError: Could not read image from camera.
# During handling of the above exception, another exception occurred:
#
# Traceback (most recent call last):
#   File "live_demo.py", line 152, in <module>
#     camera = USBCamera(width=WIDTH, height=HEIGHT, capture_fps=30)
#   File "/usr/local/lib/python3.6/dist-packages/jetcam-0.0.0-py3.6.egg/jetcam/usb_camera.py", line 28, in __init__
# RuntimeError: Could not initialize camera.  Please see error trace.

# reamer.cpp (1757) handleMessage OpenCV | GStreamer warning: Embedded video playback halted; module v4l2src0 reported: Internal data stream error.
sudo apt-get install -y v4l-utils


# ====
# Check Camera
ls -l  /dev/video*
v4l2-ctl --list-devices
v4l2-ctl --list-formats-ext -d /dev/video0
# CSI Camera Raspberry Pi Camera Module V2
# vi-output, imx219 10-0010 (platform:15c10000.vi:2):
#         /dev/video0
# Pixel Format: 'RG10'
#  Name        : 10-bit Bayer RGRG/GBGB

# USB Camera Logicool HD Webcam C270
# UVC Camera (046d:0825) (usb-3610000.xhci-2.4):
#         /dev/video1
# Pixel Format: 'YUYV'
#  Name        : YUYV 4:2:2
# Pixel Format: 'MJPG' (compressed)
#  Name        : Motion-JPEG

# Reboot
# sudo reboot


# ====
# Step 2 - Install trt_pose
cd
cd trt_pose
git clone https://github.com/NVIDIA-AI-IOT/trt_pose --depth 1
cd trt_pose
sudo python3 setup.py install


# ModuleNotFoundError: No module named 'tqdm'
sudo pip3 install tqdm
# Successfully installed tqdm-4.58.0

# ModuleNotFoundError: No module named 'pycocotools'
sudo pip3 install pycocotools
# Successfully installed pycocotools-2.0.2


# ====
# Step 3 - Run the example notebook
ls -l tasks/human_pose


# ====
# Model
# resnet18_baseline_att_224x224_A
# https://drive.google.com/open?id=1XYDdCUdiF2xxx4rznmLb62SdOUZuoNbd
FILE_ID=1XYDdCUdiF2xxx4rznmLb62SdOUZuoNbd
FILE_NAME=resnet18_baseline_att_224x224_A_epoch_249.pth
wget "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O ${FILE_NAME}
mv ${FILE_NAME} ./tasks/human_pose/

# densenet121_baseline_att_256x256_B
# https://drive.google.com/open?id=13FkJkx7evQ1WwP54UmdiDXWyFMY1OxDU
FILE_ID=13FkJkx7evQ1WwP54UmdiDXWyFMY1OxDU
FILE_NAME=densenet121_baseline_att_256x256_B_epoch_160.pth
wget "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O ${FILE_NAME}
mv ${FILE_NAME} ./tasks/human_pose/

# Download from Google Drive
# curl -sc /tmp/cookie "https://drive.google.com/uc?export=download&id=${FILE_ID}"
# CODE="$(awk '/_warning_/ {print $NF}' /tmp/cookie)"
# curl -Lb /tmp/cookie "https://drive.google.com/uc?export=download&confirm=${CODE}&id=${FILE_ID}" -o ${FILE_NAME}


# ====
# Jupyter Notebook
# https://jupyter.org/
sudo apt-get install -y libbz2-dev libsqlite3-dev libffi-dev


# ====
# notebook 6.2.0 Released: Jan 14, 2021
# https://pypi.org/project/notebook/
# Jupyter Notebook
sudo -H pip3 install notebook


# ====
# JupyterLab
# sudo -H pip3 install jupyterlab
# jupyter-lab


# jupyter --version
# jupyter core     : 4.7.1
# jupyter-notebook : 6.2.0
# qtconsole        : not installed
# ipython          : 7.16.1
# ipykernel        : 5.4.3
# jupyter client   : 6.1.11
# jjupyter lab      : not installed
# nbconvert        : 6.0.7
# ipywidgets       : 7.6.3
# nbformat         : 5.1.2
# traitlets        : 4.3.3


# ====
# sudo apt remove --purge nodejs npm
# curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# sudo apt-get update && sudo apt-get install -y yarn
# sudo apt-get install -y nodejs
# node -v
# v12.20.1
# npm -v
# 6.14.10


# ====
# Enable Jupyter Widgets UI Library ipywidgets
# ipywidgets: Interactive HTML Widgets
# https://github.com/jupyter-widgets/ipywidgets
# ImportError: IProgress not found. Please update jupyter and ipywidgets.
#  See https://ipywidgets.readthedocs.io/en/stable/user_install.html
sudo pip3 install ipywidgets
# Successfully installed ipywidgets-7.6.3 jupyterlab-widgets-1.0.0 widgetsnbextension-3.5.1


# can be skipped for notebook version 5.3 and above
# sudo jupyter nbextension enable --py --sys-prefix widgetsnbextension
# jupyter nbextension enable --py widgetsnbextension
jupyter nbextension enable --py widgetsnbextension
# Enabling notebook extension jupyter-js-widgets/extension... - Validating: OK

# Install the front-end extension to JupyterLab
# ValueError: Please install Node.js and npm before continuing installation.
#  You may be able to install Node.js from your package manager, from conda,
#   or directly from the Node.js website (https://nodejs.org).
# sudo jupyter labextension install @jupyter-widgets/jupyterlab-manager


# ====
# cd ./tasks/human_pose
# jupyter nbconvert --to python live_demo.ipynb
# cd ../..

cd
cd trt_pose/trt_pose/
cd ./tasks/human_pose

# trust script
# live_demo.ipynb
# ipython trust live_demo.ipynb
# Subcommand `ipython trust` is deprecated
jupyter trust live_demo.ipynb


# ====
# USB Camera Logicool HD Webcam C270
# camera = USBCamera(width=WIDTH, height=HEIGHT, capture_fps=30)
# from jetcam.usb_camera import USBCamera

# ====
# CSI Camera Raspberry Pi Camera Module V2
# from jetcam.csi_camera import CSICamera
# camera = CSICamera(width=WIDTH, height=HEIGHT, capture_fps=30)
# NameError: name 'CSICamera' is not defined

# ====
# CSI Camera Raspberry Pi Camera Module V2
#     "from jetcam.usb_camera import USBCamera\n",
#     "# from jetcam.csi_camera import CSICamera\n",
#     "from jetcam.utils import bgr8_to_jpeg\n",
#     "\n",
#     "camera = USBCamera(width=WIDTH, height=HEIGHT, capture_fps=30)\n",
#     "# camera = CSICamera(width=WIDTH, height=HEIGHT, capture_fps=30)\n",
sed -i 's/from jetcam.usb_camera/# from jetcam.usb_camera/' live_demo.ipynb
sed -i 's/camera = USBCamera/# camera = USBCamera/' live_demo.ipynb
sed -i 's/# from jetcam.csi_camera/from jetcam.csi_camera/' live_demo.ipynb
sed -i 's/# camera = CSICamera/camera = CSICamera/' live_demo.ipynb


# ====
jupyter notebook --ip=* --no-browser
