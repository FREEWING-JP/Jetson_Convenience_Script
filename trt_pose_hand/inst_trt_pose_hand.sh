#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/trt_pose_hand ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# Jupyter version
jupyter --version
if [ $? -ne 0 ]; then
  echo "no Jupyter Notebook or JupyterLab"
  echo "but Continue"
fi


# ===
# pip3
# which pip3
# if [ $? -eq 0 ]; then
#   sudo apt install python3-pip
# fi

# pip3 -V
# pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)


# ModuleNotFoundError: No module named 'trt_pose'
pip3 list --format=columns | grep trt-pose
if [ $? -ne 0 ]; then
  echo "no trt-pose"
  exit 0
fi


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
# numpy
pip3 list --format=columns | grep numpy
if [ $? -ne 0 ]; then
  echo "install numpy"
  sudo apt-get install -y python3-numpy
  # newest version (1:1.13.3-2ubuntu1)
fi


# scikit-learn
pip3 list --format=columns | grep scikit-learn
if [ $? -ne 0 ]; then
  echo "install scikit-learn"
  sudo apt-get install -y python3-sklearn python3-sklearn-lib
  # python3-sklearn-lib (0.19.1-3)
  # python3-sklearn (0.19.1-3)
fi

# scipy
pip3 list --format=columns | grep scipy
if [ $? -ne 0 ]; then
  echo "install scipy"
  sudo apt-get install -y python3-scipy
  # newest version (0.19.1-2ubuntu1)
fi



# ===
# ===
# https://github.com/NVIDIA-AI-IOT/trt_pose_hand

cd
git clone https://github.com/NVIDIA-AI-IOT/trt_pose_hand --depth 1
cd trt_pose_hand
pip3 install traitlets


pip3 list --format=columns | grep numpy
pip3 list --format=columns | grep scikit-learn
pip3 list --format=columns | grep scipy


# ModuleNotFoundError: No module named 'sklearn'
# Use scikit-learn instead
# sudo pip3 install sklearn
# https://pypi.org/project/scikit-learn/
# scikit-learn 0.24.1, Requires: Python >=3.6
pip3 list --format=columns | grep scikit-learn
if [ $? -ne 0 ]; then
  echo "install scikit-learn"
  sudo pip3 install scikit-learn==0.24.1
fi
# Successfully installed joblib-1.0.0 scikit-learn-0.24.1 threadpoolctl-2.1.0



# sudo pip3 install scipy==1.5.4
# numpy.distutils.system_info.NotFoundError: No lapack/blas resources found.
sudo apt-get install -y libatlas-base-dev gfortran


# ModuleNotFoundError: No module named 'numpy.testing.nosetester' #1
# https://github.com/NVIDIA-AI-IOT/trt_pose_hand/issues/1
# sudo pip uninstall numpy
# sudo pip3 install numpy==1.16.4

# https://pypi.org/project/numpy/
# numpy 1.20.1, Requires: Python >=3.7
# sudo pip3 install numpy==1.18

# https://pypi.org/project/scipy/
# scipy 1.6.0, Requires: Python >=3.7
pip3 list --format=columns | grep scipy
if [ $? -ne 0 ]; then
  echo "install scipy"
  sudo pip3 install scipy==1.5.4
fi


# sudo pip3 install scikit-learn==0.21.3

# pandas 1.1.5, Requires: Python >=3.6.1
# pip install pandas==1.1.5
# from numpy.testing import rundocs


# ====
# Model
# hand_pose_resnet18_att_244_244.pth
# https://drive.google.com/open?id=1NCVo0FiooWccDzY7hCc5MAKaoUpts3mo
FILE_ID=1NCVo0FiooWccDzY7hCc5MAKaoUpts3mo
FILE_NAME=hand_pose_resnet18_att_244_244.pth
wget "https://drive.google.com/uc?export=download&id=${FILE_ID}" -O ${FILE_NAME}
mv ${FILE_NAME} ./model/




# ====
# Jupyter Notebook


# ===
# ===
# Jupyter version
jupyter --version
if [ $? -ne 0 ]; then
  echo "no Jupyter Notebook or JupyterLab"
  exit 0
fi


# ====
cd
cd trt_pose_hand
ls -l
# live_hand_pose.ipynb
# gesture_classifier.py
# jupyter nbextension enable --py widgetsnbextension

# ====
# USB Camera Logicool HD Webcam C270

# ====
# CSI Camera Raspberry Pi Camera Module V2
# camera = USBCamera(width=WIDTH, height=HEIGHT, capture_fps=30, capture_device=1)
# #camera = CSICamera(width=WIDTH, height=HEIGHT, capture_fps=30)
sed -i 's/camera = USBCamera/# camera = USBCamera/' live_hand_pose.ipynb
sed -i 's/#camera = CSICamera/camera = CSICamera/' live_hand_pose.ipynb


# Notebook live_hand_pose.ipynb is not trusted
jupyter trust live_hand_pose.ipynb

# ====
which jupyter-lab
if [ $? -eq 0 ]; then
  jupyter-lab --ip=* --no-browser
else
  jupyter notebook --ip=* --no-browser
fi

