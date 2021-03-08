#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


TF_VER=$1


# ===
# ===
# TensorFlow version
TF_VERSION=`python3 -c "import tensorflow; print (tensorflow.VERSION)"`
if [ $? = 0 ]; then
  echo $TF_VERSION
  if [[ ${TF_VERSION} =~ ^([0-9]+)\..*$ ]]; then
    echo ${BASH_REMATCH[1]}
    if [ ! "${BASH_REMATCH[1]}" = "2" ]; then
      echo "Already Installed TensorFlow v2.x"
      exit 0
    fi
  fi

  echo "Uninstall TensorFlow"
  chmod +x uninstall.sh
  bash ./uninstall.sh
fi


# ===
# TensorFlow Build from source
# https://www.tensorflow.org/install/source
# Install Python and the TensorFlow package dependencies
echo "# ==="
echo "# Install Python and the TensorFlow package dependencies"
sudo apt-get update
sudo apt install -y python3-dev python3-pip

sudo apt-get install -y build-essential  libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zip unzip nkf

# Move to dependencies.sh
# sudo pip3 install -U six==1.15.0
# Successfully installed six-1.15.0

# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
# uff 0.6.9 requires protobuf>=3.3.0, but you have protobuf 3.0.0 which is incompatible.
# sudo pip3 install -U protobuf==3.15.5

# sudo pip3 install -U numpy==1.18.5

# sudo pip3 install -U wheel==0.36.2
# Successfully installed wheel-0.36.2

# sudo pip3 install -U keras_preprocessing --no-deps
# Successfully installed keras-preprocessing-1.1.2

chmod +x dependencies.sh
bash ./dependencies.sh $TF_VER


echo "# ==="
echo "# git clone"
cd
git clone https://github.com/tensorflow/tensorflow.git -b v2.4.1 --depth 1
cd tensorflow


(
echo   # Please specify the location of python. [Default is /usr/bin/python3]:
echo   # Do you wish to build TensorFlow with OpenCL SYCL support? [y/N]:
echo   # Do you wish to build TensorFlow with ROCm support? [y/N]:
echo Y # Do you wish to build TensorFlow with CUDA support? [y/N]: Y
echo   # Do you wish to build TensorFlow with TensorRT support? [y/N]:
echo sm_53,7.2 # Please note that each additional compute capability significantly increases your build time and binary size, and that TensorFlow only supports compute capabilities >= 3.5 [Default is: 3.5,7.0]: sm_53,7.2
echo   # Do you want to use clang as CUDA compiler? [y/N]:
echo   # Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]:
echo   # Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -Wno-sign-compare]:
echo   # Would you like to interactively configure ./WORKSPACE for Android builds? [y/N]:
) | ./configure


# if Jetson Nano Need export MAX_JOBS=1 to Reduce Memory usage
tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id
# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  echo Jetson Xavier NX
  export MAX_JOBS=2
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  echo Jetson Nano
  export MAX_JOBS=1
fi

CONFIG_V1=""
echo $CONFIG_V1
if [ $TF_VER = "v1" ]; then
  echo TensorFlow 1.x
  CONFIG_V1="--config=v1"
fi


time bazel build --jobs $MAX_JOBS $CONFIG_V1 \
 --config=cuda \
 --config=noaws \
 --config=nogcp \
 --config=nohdfs \
 --config=nonccl \
 //tensorflow/tools/pip_package:build_pip_package

# TensorFlow 1.x
# To build an older TensorFlow 1.x package, use the --config=v1 option

# Building TensorFlow from source can use a lot of RAM. If your system is memory-constrained, limit Bazel's RAM usage with: --local_ram_resources=2048
# --local_ram_resources=2048


# Install the package
# sudo pip3 install ./tmp/tensorflow_pkg/tensorflow-version-tags.whl


cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

