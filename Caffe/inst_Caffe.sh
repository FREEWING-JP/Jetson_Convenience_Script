#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/caffe ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# OpenCV version
OPENCV_VERSION=`opencv_version`
if [ $? != 0 ]; then
  echo "OpenCV not Found"
  echo "Need OpenCV v3.x"
  exit 0
fi

echo $OPENCV_VERSION
if [[ ${OPENCV_VERSION} =~ ^([0-9]+)\..*$ ]]; then
  echo ${BASH_REMATCH[1]}
  if [ ! "${BASH_REMATCH[1]}" = "3" ]; then
    echo "Need OpenCV v3.x"
    exit 0
  fi
fi


# ===
# ===
# BVLC/caffe Git clone
cd
git clone https://github.com/BVLC/caffe.git --depth 1
cd caffe

# Copy Makefile.config
cp Makefile.config.example Makefile.config
# Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)

# Edit Makefile.config
# nano Makefile.config

sed -i 's/^# USE_CUDNN/USE_CUDNN/' Makefile.config
# sed -i 's/BLAS :=.*/BLAS := atlas/' Makefile.config
sed -i 's/^INCLUDE_DIRS :=.*/INCLUDE_DIRS := $(PYTHON_INCLUDE) \/usr\/local\/include \/usr\/include\/hdf5\/serial/' Makefile.config
# sed -i 's/^LIBRARY_DIRS :=.*/LIBRARY_DIRS := $(PYTHON_LIB) \/usr\/local\/lib \/usr\/lib \/usr\/lib\/aarch64-linux-gnu\/hdf5\/serial/' Makefile.config
sed -i 's/x86_64-linux-gnu/aarch64-linux-gnu/' Makefile.config
sed -i 's/# OPENCV_VERSION/OPENCV_VERSION/' Makefile.config
sed -i 's/# WITH_PYTHON_LAYER/WITH_PYTHON_LAYER/' Makefile.config

# ===
# ===
tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  # Jetson Xavier NX sm_72
  # CUDA_ARCH := -gencode arch=compute_72,code=sm_72 \
  #                -gencode arch=compute_72,code=compute_72
  sed -i 's/arch=compute_20,code=sm_20/arch=compute_72,code=sm_72/' Makefile.config
  sed -i 's/arch=compute_20,code=sm_21 \\/arch=compute_72,code=compute_72/' Makefile.config
  sed -i '/arch=compute_30,code=sm_30 \\/d' Makefile.config
  sed -i '/arch=compute_35,code=sm_35 \\/d' Makefile.config
  sed -i '/arch=compute_50,code=sm_50 \\/d' Makefile.config
  sed -i '/arch=compute_52,code=sm_52 \\/d' Makefile.config
  sed -i '/arch=compute_60,code=sm_60 \\/d' Makefile.config
  sed -i '/arch=compute_61,code=sm_61 \\/d' Makefile.config
  sed -i '/arch=compute_61,code=compute_61/d' Makefile.config
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  # Jetson Nano sm_53
  sed -i 's/arch=compute_20,code=sm_20 \\/arch=compute_53,code=sm_53/' Makefile.config
  # sed -i 's/-gencode arch=compute_20,code=sm_21 \\//' Makefile.config
  # Makefile.config:41: *** recipe commences before first target.  Stop.
  sed -i '/arch=compute_20,code=sm_21 \\/d' Makefile.config
  sed -i '/arch=compute_30,code=sm_30 \\/d' Makefile.config
  sed -i '/arch=compute_35,code=sm_35 \\/d' Makefile.config
  sed -i '/arch=compute_50,code=sm_50 \\/d' Makefile.config
  sed -i '/arch=compute_52,code=sm_52 \\/d' Makefile.config
  sed -i '/arch=compute_60,code=sm_60 \\/d' Makefile.config
  sed -i '/arch=compute_61,code=sm_61 \\/d' Makefile.config
  sed -i '/arch=compute_61,code=compute_61/d' Makefile.config
fi

# ===
# OpenBlas
sed -i 's/BLAS :=.*/BLAS := open/' Makefile.config


# ===
# Install Dependencies
# Makefile.config
sudo apt-get -y install protobuf-compiler libprotoc-dev libboost-dev libgflags-dev libgoogle-glog-dev libhdf5-dev libleveldb-dev liblmdb-dev libopencv-dev libsnappy-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev libboost-python-dev python-skimage python-protobuf python-numpy python-pil

# libboost-regex-dev
sudo apt-get -y install libboost-regex-dev

# ===
# BLAS
grep "^BLAS := open" Makefile.config
if [ $? = 0 ]; then
  # OpenBLAS, BLAS := open
  sudo apt-get -y install libopenblas-base libopenblas-dev
else
  # ATLAS, BLAS := atlas
  sudo apt-get install libatlas-base-dev
fi


# ===
# Build
echo "Make Caffe."
echo "========== time make -j$(nproc)"
make clean

time make all -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

# ./.build_release/tools/caffe -version
# caffe version 1.0.0


echo "========== time make test -j$(nproc)"
# make test make runtest
time make test -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

echo "========== time make runtest -j$(nproc)"
time make runtest -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

# Python Caffe distribute
make pycaffe
make distribute


# export CAFFE_HOME=/home/user/caffe
export CAFFE_HOME=$(pwd)

echo ${CAFFE_HOME}
# /home/jetson/caffe

ls -l ${CAFFE_HOME}/python
ls -l ${CAFFE_HOME}/distribute/lib

#
export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH
export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH


# ===
# add Caffe environment variable
echo "export CAFFE_HOME=${CAFFE_HOME}" >> ~/.bashrc
echo 'export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH' >> ~/.bashrc


# ===
python -c "import caffe; print(caffe.__version__)"
# 1.0.0
python3 -c "import caffe; print(caffe.__version__)"
# Err


# ===
# NVIDIA OpenPose
echo ${CAFFE_HOME}
# /home/jetson/caffe

# NVIDIA OpenPose (NVCaffe)
# fatal error half_float/half.hpp No such file or directory
# cp -r ${CAFFE_HOME}/3rdparty/* ${CAFFE_HOME}/include
# */

# fatal error caffe/proto/caffe.pb.h No such file or directory
cd ${CAFFE_HOME}
protoc src/caffe/proto/caffe.proto --cpp_out=.
mkdir include/caffe/proto
mv src/caffe/proto/caffe.pb.h include/caffe/proto

# ===
echo "export CAFFE_HOME=${CAFFE_HOME}"
echo 'export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH'
echo 'export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH'
echo "type 'source ~/.bashrc'"
echo ''
echo "source ~/.bashrc"
echo 'echo ${CAFFE_HOME}'
echo ''


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi
