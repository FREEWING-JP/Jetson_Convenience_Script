#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/openpose ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# Required CMake version >= 3.12
cmake --version

# Check cmake version
cmake --version | grep "version 3.10"
if [ $? = 0 ]; then
  echo "Error CMake version too old"
  exit 0
fi

# cmake version 3.14.0
cmake --version | grep "version 3.14"
if [ $? = 0 ]; then
  echo "CMake version OK"
fi

# cmake version 3.17.3
cmake --version | grep "version 3.17"
if [ $? = 0 ]; then
  echo "CMake version OK"
fi


# ===
# OpenCV version
OPENCV_VERSION=`opencv_version`
if [ $? != 0 ]; then
  echo "OpenCV not Found"
  echo "Need OpenCV v3.x/v4.x"
  exit 1
fi

echo $OPENCV_VERSION
if [[ ${OPENCV_VERSION} =~ ^([0-9]+)\..*$ ]]; then
  echo ${BASH_REMATCH[1]}
  case "${BASH_REMATCH[1]}" in
      "3")
        echo "OpenCV v3.x"
        OPENCV_VERSION=3
        OpenCV_DIR=/usr/local/share/OpenCV
        ;;
      "4")
        echo "OpenCV v4.x"
        OPENCV_VERSION=4
        OpenCV_DIR=/usr/local/lib/cmake/opencv4
        ;;
      *)
        echo "Need OpenCV v3.x/v4.x"
        exit 1
        ;;
  esac

  ls -l ${OpenCV_DIR}

fi


BUILD_CAFFE_PYTHON_VERSION=3
DOWNLOAD_BODY_COCO_MODEL=OFF
DOWNLOAD_BODY_MPI_MODEL=OFF

# ===
echo $CAFFE_HOME
if [ "${CAFFE_HOME}" = "" ]; then
  echo "No CAFFE_HOME env."
  echo "Build OpenPose Caffe"

  read -p "Build OpenPose Caffe's Python version ? (2/3/N):" ver
  case "$ver" in 2) BUILD_CAFFE_PYTHON_VERSION=2 ;; 3) ;; *) echo "Abort" ; exit 1 ;; esac

fi


# ===
read -p "Download COCO and MPI model ? (y/N):" yn
case "$yn" in [yY]*) DOWNLOAD_BODY_COCO_MODEL=ON DOWNLOAD_BODY_MPI_MODEL=ON ;; *) echo "No" ;; esac


# ===
if [ "${CAFFE_HOME}" != "" ]; then

  CAFFE_VERSION=`python -c "import caffe; print(caffe.__version__)"`
  if [ $? -ne 0 ]; then
    CAFFE_VERSION=`python3 -c "import caffe; print(caffe.__version__)"`
  fi

  # Check NV_Caffe 0.17.3
  echo $CAFFE_VERSION | grep "0.17.3"
  if [ $? -ne 0 ]; then
    ESC=$(printf '\033')
    echo ''
    echo "${ESC}[41mOpenPose probably doesn't work except for Caffe version 0.17.3${ESC}[m"
    echo ''
    # echo "Check failed: status == CUDNN_STATUS_SUCCESS (4 vs. 0)  CUDNN_STATUS_INTERNAL_ERROR, device 0"
    echo 'google/protobuf/message_lite.cc:118 Can't parse message of type "caffe.NetParameter" because it is missing required fields: layer[0].clip_param.min, layer[0].clip_param.max'
    echo 'upgrade_proto.cpp:97 Check failed: ReadProtoFromBinaryFile(param_file, param) Failed to parse NetParameter file: ./models/pose/body_25/pose_iter_584000.caffemodel'
    echo ''

    read -p "Continue ? (y/N):" yn
    case "$yn" in [yY]*) ;; *) echo "Abort" ; exit 1 ;; esac

  fi

  # ===
  CAFFE_PATH=${CAFFE_HOME}

  echo ${CAFFE_PATH}

  # /home/jetson/nvcaffe/include
  Caffe_INCLUDE_DIRS=${CAFFE_PATH}/include

  # ls -l ${CAFFE_PATH}/build/lib/
  # libcaffe-nv.so
  if [ -e ${CAFFE_PATH}/build/lib/libcaffe.so ]; then
    Caffe_LIBS=${CAFFE_PATH}/build/lib/libcaffe.so
    DL_FRAMEWORK=CAFFE
  fi
  if [ -e ${CAFFE_PATH}/build/lib/libcaffe-nv.so ]; then
    Caffe_LIBS=${CAFFE_PATH}/build/lib/libcaffe-nv.so
    DL_FRAMEWORK=NV_CAFFE
  fi

  ls -l ${Caffe_INCLUDE_DIRS}
  ls -l ${Caffe_LIBS}

  echo ${Caffe_INCLUDE_DIRS}
  echo ${Caffe_LIBS}
  echo ${DL_FRAMEWORK}

fi


# ===
# build OpenPose
cd
# OpenPose v1.6.0 Apr 27, 2020
git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose -b v1.6.0 --depth 1
cd openpose
sudo bash ./scripts/ubuntu/install_deps.sh


# ===
cp $SCRIPT_DIR/execute_sample.sh .
chmod +x ./execute_sample.sh


# ===
if [ "${CAFFE_HOME}" != "" ]; then
  # ===
  # Linking CXX executable resizeTest.bin
  # resizeTest.cpp.o: undefined reference to symbol '_ZN5boost6system15system_categoryEv'
  # //usr/lib/aarch64-linux-gnu/libboost_system.so.1.65.1: error adding symbols: DSO missing from command line
  sed -i 's/resizeTest.cpp)/)/' ./examples/tests/CMakeLists.txt
  cat ./examples/tests/CMakeLists.txt | grep resizeTest

fi


# ===
mkdir build
cd build

# ===
# JetPack 4.4 DP Developer Preview patch
# -- CUDA detected: 10.2
# -- Found cuDNN: ver. ??? found (include: /usr/include, library: /usr/lib/aarch64-linux-gnu/libcudnn.so)
# CMake Error at cmake/Cuda.cmake:263 (message):
#   cuDNN version >3 is required.
# Call Stack (most recent call first):
#   cmake/Cuda.cmake:291 (detect_cuDNN)
#   CMakeLists.txt:422 (include)
# L4T 32.4.2 = JetPack 4.4
cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 4.2"
# R32 (release), REVISION: 4.2, GCID: 20074772, BOARD: t186ref, EABI: aarch64, DATE: Thu Apr  9 01:26:40 UTC 2020
if [ $? = 0 ]; then
  # L4T 32.4.2 = JetPack 4.4
  echo "JetPack 4.4"

  # Change cudnn.h to cudnn_version.h
  sed -i -e "s/cudnn.h/cudnn_version.h/g" ../cmake/Cuda.cmake
  sed -i -e "s/cudnn.h/cudnn_version.h/g" ../cmake/Modules/FindCuDNN.cmake
fi


# ===
# NVIDIA CUDA GPUs Compute Capability
# https://developer.nvidia.com/cuda-gpus
# Compute Capability Jetson Nano = 5.3
# -D CUDA_ARCH_BIN="5.3"
# Compute Capability Jetson Xavier = 7.2
# -D CUDA_ARCH_BIN="7.2"

tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

CUDA_ARCH_BIN=5.3

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  CUDA_ARCH_BIN=7.2
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  CUDA_ARCH_BIN=5.3
fi

# ===
# -D CMAKE_BUILD_TYPE=Release
# https://cmake.org/cmake/help/v3.17/variable/CMAKE_BUILD_TYPE.html
# CMAKE_BUILD_TYPE Possible values are empty, Debug, Release, RelWithDebInfo, MinSizeRel
echo "========== cmake"
if [ "${CAFFE_HOME}" = "" ]; then

  cmake .. \
    -D CMAKE_BUILD_TYPE=Release \
    \
    -D DOWNLOAD_BODY_COCO_MODEL=${DOWNLOAD_BODY_COCO_MODEL} \
    -D DOWNLOAD_BODY_MPI_MODEL=${DOWNLOAD_BODY_MPI_MODEL} \
    \
    -D CUDA_ARCH_BIN=$CUDA_ARCH_BIN

  if [ $? != 0 ]; then
    echo "=========="
    echo "=== NG ==="
    echo "=========="
    exit 1
  fi

fi

if [ "${CAFFE_HOME}" != "" ]; then

  cmake .. \
    -D CMAKE_BUILD_TYPE=Release \
    \
    -D OpenCV_DIR=${OpenCV_DIR} \
    \
    -D DOWNLOAD_BODY_COCO_MODEL=${DOWNLOAD_BODY_COCO_MODEL} \
    -D DOWNLOAD_BODY_MPI_MODEL=${DOWNLOAD_BODY_MPI_MODEL} \
    \
    -D BUILD_CAFFE=OFF \
    -D DL_FRAMEWORK=${DL_FRAMEWORK} \
    -D Caffe_INCLUDE_DIRS=${Caffe_INCLUDE_DIRS} \
    -D Caffe_LIBS=${Caffe_LIBS} \
    -D Caffe_LIBS_RELEASE=${Caffe_LIBS}

  if [ $? != 0 ]; then
    echo "=========="
    echo "=== NG ==="
    echo "=========="
    exit 1
  fi

fi


if [ "${CAFFE_HOME}" = "" ]; then
  # ===
  # JetPack 4.4 DP Developer Preview patch
  cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 4.2"
  # R32 (release), REVISION: 4.2, GCID: 20074772, BOARD: t186ref, EABI: aarch64, DATE: Thu Apr  9 01:26:40 UTC 2020
  if [ $? = 0 ]; then
    # L4T 32.4.2 = JetPack 4.4
    echo "JetPack 4.4"

    # Caffe Configuration
    # Change cudnn.h to cudnn_version.h
    sed -i -e "s/cudnn.h/cudnn_version.h/g" ../3rdparty/caffe/cmake/Cuda.cmake
  fi
fi

# master (HEAD detached at c95002fb)
# https://github.com/CMU-Perceptual-Computing-Lab/caffe/commits/master
if [ "${CAFFE_HOME}" = "" ]; then
  if [ $OPENCV_VERSION = 4 ]; then
    echo "OpenPose Caffe OpenCV 4.x patch"

    # Build Caffe Python version
    if [ ${BUILD_CAFFE_PYTHON_VERSION} -eq 2 ]; then
      cp $SCRIPT_DIR/open_cv4_patch/Makefile_py2 ../3rdparty/caffe/Makefile
    else
      cp $SCRIPT_DIR/open_cv4_patch/Makefile_py3 ../3rdparty/caffe/Makefile
    fi

    cp $SCRIPT_DIR/open_cv4_patch/common.hpp ../3rdparty/caffe/include/caffe/
    cp $SCRIPT_DIR/open_cv4_patch/common_cv4.hpp ../3rdparty/caffe/include/caffe/

    # ===
    # OpenBlas
    sed -i 's/^BLAS ?= atlas/BLAS ?= open/' ../3rdparty/caffe/Makefile

    # ===
    # BLAS
    grep "^BLAS ?= open" ../3rdparty/caffe/Makefile
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
        echo "install libopenblas-dev"
        sudo apt-get -y install libopenblas-dev
      else
        echo "remove libopenblas-base libopenblas-dev"
        sudo apt-get -y remove libopenblas-base libopenblas-dev
      fi
    else
      # ATLAS, BLAS := atlas
      sudo apt-get install libatlas-base-dev
    fi

  fi
fi


# ===
echo "========== time make -j$(nproc)"
make clean
time make -j$(nproc)
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi


# ===
echo "========== sudo make install"
sudo make install
if [ $? != 0 ]; then
  echo "=========="
  echo "=== NG ==="
  echo "=========="
  exit 1
fi

cd ..

TF_DIR=$(pwd)
echo $TF_DIR


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi


# ===
# FFmpeg for Output movie
ffmpeg -version
if [ $? != 0 ]; then
  sudo apt-get -y install ffmpeg
fi


# ===
# execute sample
# cd
# cd openpose
cd $TF_DIR
bash ./execute_sample.sh

