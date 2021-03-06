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
if [ $? = 0 ]; then
  echo "Already Installed Pytorch"
  exit 0
fi

TF_VERSION=`python3 -c "import torchvision; print (torchvision.__version__)"`
if [ $? = 0 ]; then
  echo "Already Installed torchvision"
  exit 0
fi


# https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-7-0-now-available/72048
# Build wheel for Python 3.6 (to pytorch/dist)
sudo apt-get install -y python3-pip cmake libopenblas-dev

export USE_NCCL=0
# skip setting this if you want to enable OpenMPI backend
export USE_DISTRIBUTED=0
export USE_QNNPACK=0
export USE_PYTORCH_QNNPACK=0
export TORCH_CUDA_ARCH_LIST="5.3;6.2;7.2"

# without the leading 'v', e.g. 1.3.0 for PyTorch v1.3.0
export PYTORCH_BUILD_VERSION=$PYTORCH_VERSION
export PYTORCH_BUILD_NUMBER=1

cd
git clone --recursive --branch v$PYTORCH_BUILD_VERSION http://github.com/pytorch/pytorch --depth 1
cd pytorch

# Apply Patch PyTorch issue #8103
# too many CUDA resources requested for launch error
# https://github.com/pytorch/pytorch/issues/8103#issuecomment-514802040

# https://gist.github.com/dusty-nv/ce51796085178e1f38e3c6a1663a93a1#file-pytorch-1-7-jetpack-4-4-1-patch
# // See https://github.com/pytorch/pytorch/issues/47098
# // patch for gcc 7 bug returns incorrect result on aarch64 if compiled by gcc-7.5.0
sed -i 's/#if defined(__aarch64__)/#if defined(__aarch64__)\n#if defined(__clang__) || (__GNUC__ > 8 || (__GNUC__ == 8 \&\& __GNUC_MINOR__ > 3))/' aten/src/ATen/cpu/vec256/vec256_float_neon.h

sed -i 's/}}}/#endif\n}}}/' aten/src/ATen/cpu/vec256/vec256_float_neon.h


# #if !defined(__clang__) && !(__GNUC__ > 8 || (__GNUC__ == 8 && __GNUC_MINOR__ > 3))
#   #error Clang C++ compiler required .
# #endif


# // patch for "too many resources requested for launch"
sed -i 's/device_prop, device_index));$/device_prop, device_index));\n  device_prop.maxThreadsPerBlock = device_prop.maxThreadsPerBlock \/ 2;/' aten/src/ATen/cuda/CUDAContext.cpp
grep maxThreadsPerBlock aten/src/ATen/cuda/CUDAContext.cpp

# // patch for "too many resources requested for launch"
sed -i 's/int CUDA_NUM_THREADS = .*;/int CUDA_NUM_THREADS = 512;/' aten/src/ATen/cuda/detail/KernelUtils.h
grep CUDA_NUM_THREADS aten/src/ATen/cuda/detail/KernelUtils.h

# // patch for "too many resources requested for launch"
sed -i 's/int CUDA_NUM_THREADS = .*;/int CUDA_NUM_THREADS = 512;/' aten/src/THCUNN/common.h
grep CUDA_NUM_THREADS aten/src/THCUNN/common.h

sudo pip3 install -r requirements.txt
sudo pip3 install scikit-build
# Successfully installed distro-1.5.0 packaging-20.9 pyparsing-2.4.7 scikit-build-0.11.1

sudo pip3 install ninja
# Successfully installed ninja-1.10.0.post2

free -h
# Jetson Xavier NX
#               total        used        free      shared  buff/cache   available
# Mem:           7.6G        305M        5.1G         20M        2.2G        7.1G
# Swap:          3.8G          0B        3.8G

# Jetson Nano
#               total        used        free      shared  buff/cache   available
# Mem:           3.9G        225M        1.5G         18M        2.1G        3.5G
# Swap:          1.9G          0B        1.9G

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
  export MAX_JOBS=3
fi
# Allowing ninja to set a default number of workers... (overridable by setting the environment variable MAX_JOBS=N)


time python3 setup.py bdist_wheel
# Jetson Xavier NX
# real    355m36.122s
# user    1941m55.096s
# sys     78m0.800s

# Jetson Nano
# real    698m59.398s
# user    1927m0.192s
# sys     80m49.916s


find ./ -name "*.whl"
# ./dist/torch-1.7.1-cp36-cp36m-linux_aarch64.whl

ls -l ./dist/torch-*.whl
# -rw-rw-r-- 1 jetson jetson 249073141 Mar  1 22:24 ./dist/torch-1.7.1-cp36-cp36m-linux_aarch64.whl

# Install PyTorch 1.7.1 from wheel
sudo apt-get install -y libopenblas-base libopenmpi-dev

# RuntimeError: Python version >= 3.7 required
sudo pip3 install Cython==0.29.22
sudo pip3 install numpy==1.19.5


#     The headers or library files could not be found for jpeg,
#     a required dependency when compiling Pillow from source.
#
#     Please see the install instructions at:
#        https://pillow.readthedocs.io/en/latest/installation.html
# Prerequisites for Ubuntu 16.04 LTS - 20.04 LTS are installed with
# https://pillow.readthedocs.io/en/latest/installation.html
sudo apt-get install -y libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python3-tk \
    libharfbuzz-dev libfribidi-dev libxcb1-dev

sudo pip3 install Pillow==8.1.0
sudo pip3 install matplotlib==3.3.3

# sudo pip3 install --upgrade --force-reinstall ./dist/torch-1.7.1-cp36-cp36m-linux_aarch64.whl

sudo pip3 install ./dist/torch-$PYTORCH_VERSION-cp${PYTHON_VERSION}-cp${PYTHON_VERSION}m-linux_aarch64.whl
# Successfully installed torch-1.7.1

pip3 list --format=legacy | grep torch
# torch (1.7.1)

cd
python3 -c "import torch; print(torch.__version__); print(torch.cuda.is_available()); print(torch.cuda.get_device_name())"
# Jetson Xavier NX
# 1.7.1
# True
# Xavier

# Jetson Nano
# 1.7.1
# True
# NVIDIA Tegra X1

# torchvision v0.8.2
sudo apt-get install -y libavcodec-dev
sudo apt-get install -y libavformat-dev
sudo apt-get install -y libswscale-dev

cd
git clone --recursive --branch v$TORCHVISION_VERSION https://github.com/pytorch/vision --depth 1
cd vision

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


cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi
