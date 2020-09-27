#!/bin/sh

# Caffe installation on Xavier
# https://forums.developer.nvidia.com/t/caffe-installation-on-xavier/67730

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/caffe_nv ]; then
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
# 4. Get source
cd
git clone https://github.com/BVLC/caffe.git caffe_nv --depth 1
cd caffe_nv


# ===
# 1. Setup
sudo apt-get update
# sudo apt-get -y install software-properties-common
# sudo add-apt-repository universe 
# sudo add-apt-repository multiverse


# ===
# 2. Install dependencies
sudo apt-get -y install libboost-dev libboost-all-dev
sudo apt-get -y install libgflags-dev libgoogle-glog-dev liblmdb-dev libatlas-base-dev liblmdb-dev libblas-dev libatlas-base-dev libprotobuf-dev libleveldb-dev libsnappy-dev libhdf5-serial-dev protobuf-compiler


# ===
# 3. hdf5
# sudo ln -s libhdf5_serial.so libhdf5.so
# sudo ln -s libhdf5_serial_hl.so libhdf5_hl.so


# ===
# 5. Apply changes
# Makefile
sed -i 's/^LIBRARIES +=.*/LIBRARIES += glog gflags protobuf boost_system boost_filesystem m hdf5_serial_hl hdf5_serial/' Makefile

# Copy Makefile.config
cp Makefile.config.example Makefile.config
# Adjust Makefile.config (for example, if using Anaconda Python, or if cuDNN is desired)

# Edit Makefile.config
# nano Makefile.config

sed -i 's/^# USE_CUDNN/USE_CUDNN/' Makefile.config
sed -i 's/^# OPENCV_VERSION/OPENCV_VERSION/' Makefile.config
sed -i 's/^INCLUDE_DIRS :=.*/INCLUDE_DIRS := $(PYTHON_INCLUDE) \/usr\/local\/include \/usr\/include\/hdf5\/serial/' Makefile.config
sed -i 's/x86_64-linux-gnu/aarch64-linux-gnu/' Makefile.config
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

