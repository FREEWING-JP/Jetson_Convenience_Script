#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


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
sudo ldconfig


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
grep "^export CAFFE_HOME=" ~/.bashrc
if [ $? = 0 ]; then
  # 2nd
  sed -i "s@^export CAFFE_HOME=.*@export CAFFE_HOME=${CAFFE_HOME}@" ~/.bashrc
else
  # 1st
  echo '# Caffe' >> ~/.bashrc
  echo "export CAFFE_HOME=${CAFFE_HOME}" >> ~/.bashrc
  echo 'export PYTHONPATH=${CAFFE_HOME}/python:$PYTHONPATH' >> ~/.bashrc
  echo 'export LD_LIBRARY_PATH=${CAFFE_HOME}/distribute/lib:$LD_LIBRARY_PATH' >> ~/.bashrc
fi


# ===
python -c "import caffe; print(caffe.__version__)"
# Err or 1.0.0 or 0.17.3
python3 -c "import caffe; print(caffe.__version__)"
# Err or 1.0.0 or 0.17.3


# ===
# NVIDIA OpenPose
echo ${CAFFE_HOME}
# /home/jetson/caffe

if [ -d ${CAFFE_HOME}/3rdparty/half_float ]; then
  # NVIDIA OpenPose (NVCaffe)
  # fatal error half_float/half.hpp No such file or directory
  cp -r ${CAFFE_HOME}/3rdparty/* ${CAFFE_HOME}/include
  # */
fi


# fatal error caffe/proto/caffe.pb.h No such file or directory
cd ${CAFFE_HOME}
protoc src/caffe/proto/caffe.proto --cpp_out=.
mkdir include/caffe/proto
mv src/caffe/proto/caffe.pb.h include/caffe/proto

# ===
source ~/.bashrc

grep " CAFFE_HOME=" ~/.bashrc
grep " PYTHONPATH=" ~/.bashrc
grep " LD_LIBRARY_PATH=.*CAFFE_HOME" ~/.bashrc

# ===
echo '---'
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

