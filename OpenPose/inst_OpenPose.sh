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
cmake --version | grep "version 3\.1[0-1]"
if [ $? = 0 ]; then
  echo "Error CMake version too old"
  exit 0
fi

# cmake version 3.12 - 3.19 or 3.20 later
cmake --version | grep -E "version 3\.(1[2-9]|2[0-9])"
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


DOWNLOAD_BODY_COCO_MODEL=OFF
DOWNLOAD_BODY_MPI_MODEL=OFF

# ===
read -p "Download COCO and MPI model ? (y/N):" yn
case "$yn" in [yY]*) DOWNLOAD_BODY_COCO_MODEL=ON DOWNLOAD_BODY_MPI_MODEL=ON ;; *) echo "No" ;; esac


# ===
if [ "${CAFFE_HOME}" != "" ]; then

  CAFFE_VERSION=`python -c "import caffe; print(caffe.__version__)"`
  if [ $? -ne 0 ]; then
    CAFFE_VERSION=`python3 -c "import caffe; print(caffe.__version__)"`
  fi

  # Check NV_Caffe 0.17.3 or later
  echo $CAFFE_VERSION | grep "0\.17\.[3-9]"
  if [ $? -ne 0 ]; then
    ESC=$(printf '\033')
    echo ''
    echo "${ESC}[41mOpenPose probably doesn't work except for Caffe version 0.17.3/0.17.4${ESC}[m"
    echo ''
    # echo "Check failed: status == CUDNN_STATUS_SUCCESS (4 vs. 0)  CUDNN_STATUS_INTERNAL_ERROR, device 0"
    echo "google/protobuf/message_lite.cc:118 Can't parse message of type \"caffe.NetParameter\" because it is missing required fields: layer[0].clip_param.min, layer[0].clip_param.max"
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
# OpenPose v1.7.0 17 Nov 2020
git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose -b v1.7.0 --depth 1
cd openpose

# Collecting opencv-python
# File "/tmp/pip-build-vosno9nt/opencv-python/setup.py", line 10, in <module>
# import skbuild
# ModuleNotFoundError: No module named 'skbuild'
# Command "python setup.py egg_info" failed with error code 1 in /tmp/pip-build-vosno9nt/opencv-python/
# sudo pip3 install scikit-build
# sudo apt-get -y install python3-skimage

# Cythonizing sources
# File "/tmp/pip-build-uxjr2dn0/numpy/tools/cythonize.py", line 59, in process_pyx
# from Cython.Compiler.Version import version as cython_version
# ModuleNotFoundError: No module named 'Cython'
# sudo pip3 install --no-binary :all: --no-cache-dir Cython

# Running setup.py bdist_wheel for opencv-python
# Comment install scikit-build and Cython
# because opencv-python VERY VERY LONG TIME to pip install

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
USE_CUDNN=ON


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
    -D USE_CUDNN=${USE_CUDNN}

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

# Jetson Xavier NX
# time make -j6
# real    16m57.283s
# user    78m14.032s
# sys     4m14.352s


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

# Jetson Xavier NX
# Picture --net_resolution -1x240 Killed
# Picture --net_resolution -1x160 Killed
# Picture --net_resolution 320x-1 Killed
# Picture --net_resolution 240x-1 Killed

# Video
# --video Total time: 55.880033 seconds.

