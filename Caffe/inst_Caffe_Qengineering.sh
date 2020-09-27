#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/qecaffe ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# OpenCV version
OPENCV_VERSION=`opencv_version`
if [ $? != 0 ]; then
  echo "OpenCV not Found"
  echo "Need OpenCV v4.x"
  exit 0
fi

echo $OPENCV_VERSION
if [[ ${OPENCV_VERSION} =~ ^([0-9]+)\..*$ ]]; then
  echo ${BASH_REMATCH[1]}
  if [ ! "${BASH_REMATCH[1]}" = "4" ]; then
    echo "Need OpenCV v4.x"
    exit 0
  fi
fi


# ===
# ===
echo "Qengineering/caffe Git clone"
echo "Special adapted for OpenCV 4.1 and Python 3.6+"
# https://qengineering.eu/install-caffe-on-ubuntu-18.04-with-opencv-4.1.html
cd
git clone https://github.com/Qengineering/caffe qecaffe --depth 1
# wget -O qecaffe.zip https://github.com/Qengineering/caffe/archive/master.zip
# unzip qecaffe.zip
# mv caffe-master qecaffe
cd qecaffe


# ===
sudo apt-get -y install pkg-config
sudo apt-get -y install python3-dev python3-numpy python3-pip

# ===
# Caffe dependencies
echo "Caffe dependencies"
sudo apt-get -y install libprotobuf-dev libleveldb-dev liblmdb-dev
# sudo apt-get -y install libsnappy-dev libopencv-dev
sudo apt-get -y install libhdf5-serial-dev
# sudo apt-get -y install protobuf-compiler
# sudo apt-get -y install --no-install-recommends libboost-all-dev
# sudo apt-get -y install libatlas-base-dev libopenblas-dev
# ModuleNotFoundError: No module named 'skimage'
sudo apt-get -y install python3-skimage
# sudo pip3 install pydot
# sudo apt-get -y install graphviz

# ===
# Makefile
# PYTHON_LIBRARIES ?= boost_python python3.6
# jetson@linux:~ $ python3 -V
# Python 3.6.9


pkg-config --libs opencv4

dpkg -L libhdf5-dev


# Copy Makefile.config
cp Makefile.config.example Makefile.config
# Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)

# Edit Makefile.config
# nano Makefile.config

sed -i 's/^# USE_CUDNN/USE_CUDNN/' Makefile.config
sed -i 's/^# USE_OPENCV := 0/USE_OPENCV := 1/' Makefile.config
sed -i 's/^# USE_PKG_CONFIG/USE_PKG_CONFIG/' Makefile.config
#sed -i 's/^INCLUDE_DIRS :=.*/INCLUDE_DIRS := $(PYTHON_INCLUDE) \/usr\/local\/include \/usr\/include\/hdf5\/serial/' Makefile.config
sed -i 's/^LIBRARY_DIRS :=.*/LIBRARY_DIRS := $(PYTHON_LIB) \/usr\/local\/lib \/usr\/lib \/usr\/lib\/aarch64-linux-gnu\/hdf5\/serial/' Makefile.config


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
  sed -i 's/arch=compute_20,code=sm_20/arch=compute_53,code=sm_53/' Makefile.config
  # sed -i 's/-gencode arch=compute_20,code=sm_21 \\//' Makefile.config
  # Makefile.config:41: *** recipe commences before first target.  Stop.
  sed -i 's/arch=compute_20,code=sm_21 \\/arch=compute_53,code=compute_53/' Makefile.config
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
sed -i 's/^BLAS :=.*/BLAS := open/' Makefile.config


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
  libopenblas=0
  if [ "$BLAS_INCLUDE" = "" ]; then
    echo $LD_LIBRARY_PATH | grep "OpenBLAS"
    if [ $? -ne  0 ]; then
      libopenblas=1
    fi
  fi
  if [ $libopenblas -eq 1 ]; then
    echo "install libopenblas-base libopenblas-dev"
    sudo apt-get -y install libopenblas-base libopenblas-dev
  else
    echo "remove libopenblas-base libopenblas-dev"
    sudo apt-get -y remove libopenblas-base libopenblas-dev

    # BLAS_INCLUDE := /opt/OpenBLAS/include
    # BLAS_LIB := /opt/OpenBLAS/lib
    sed -i 's/^# BLAS_INCLUDE :=/BLAS_INCLUDE :=/' Makefile.config
    sed -i 's/^BLAS_INCLUDE :=.*/BLAS_INCLUDE := \/opt\/OpenBLAS\/include/' Makefile.config
    sed -i 's/^# BLAS_LIB :=/BLAS_LIB :=/' Makefile.config
    sed -i 's/^BLAS_LIB :=.*/BLAS_LIB := \/opt\/OpenBLAS\/lib/' Makefile.config
  fi
else
  # ATLAS, BLAS := atlas
  sudo apt-get install libatlas-base-dev
fi


# ===
# Build
echo "Make Caffe."
cp $SCRIPT_DIR/make_Caffe.sh .
chmod +x ./make_Caffe.sh
bash ./make_Caffe.sh


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

