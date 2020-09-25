#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/tf-pose-estimation ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# https://github.com/gsethi2409/tf-pose-estimation
# tf-pose-estimation by Ildoo Kim modified to work with Tensorflow 2.0+

# Pre-Install Jetson case
sudo apt-get -y install libllvm-7-ocaml-dev libllvm7 llvm-7 llvm-7-dev llvm-7-doc llvm-7-examples llvm-7-runtime
export LLVM_CONFIG=/usr/bin/llvm-config-7

ls -l $LLVM_CONFIG

# ===
# add LLVM_CONFIG environment variable
echo "export LLVM_CONFIG=${LLVM_CONFIG}" >> ~/.bashrc


# pip3 install -r requirements.txt
# Failed building wheel for matplotlib
# Failed building wheel for llvmlite
sudo apt-get -y install libfreetype6-dev
sudo apt-get -y install libpng-dev

# Install Clone the repo and install 3rd-party libraries.
cd
git clone https://github.com/ildoonet/tf-pose-estimation --depth 1
cd tf-pose-estimation

# pip3 install -r requirements.txt
# ERROR: scikit-image 0.17.2 has requirement scipy>=1.0.1, but you'll have scipy 0.19.1 which is incompatible.'
# tensorflow 2.2.0+nv20.8 requires scipy==1.4.1;
pip3 install scipy==1.4.1

# sed -i 's/llvmlite/llvmlite==0.31.0/g' requirements.txt
# RuntimeError: Building llvmlite requires LLVM 10.0.x or 9.0.x, got '7.0.0'. Be sure to set LLVM_CONFIG to the right executable path.
pip3 install llvmlite==0.31.0

# sed -i 's/numba/numba==0.48.0/g' requirements.txt
pip3 install numba==0.48.0
# Successfully installed llvmlite-0.31.0 numba-0.48.0

# requirements.txt
pip3 install -r requirements.txt


# ===
# ===
# post-processing for Part-Affinity Fields Map implemented in C++ & SWIG
# Build c++ library for post processing
# https://github.com/ildoonet/tf-pose-estimation/tree/master/tf_pose/pafprocess
cd tf_pose/pafprocess

# -bash: swig: command not found
# Need to install SWIG Simplified Wrapper and Interface Generator
# http://www.swig.org/
sudo apt -y install swig

swig -python -c++ pafprocess.i && python3 setup.py build_ext --inplace
# debconf: delaying package configuration, since apt-utils is not installed
# ENV DEBCONF_NOWARNINGS yes
# ENV DEBIAN_FRONTEND noninteractive
cd ../..


# ===
# ===
cd models/graph/cmu
bash download.sh
cd ../../..


# ModuleNotFoundError: No module named 'tf_slim'
pip3 install tf_slim


TF_POSE_DIR=$(pwd)
echo $TF_POSE_DIR


# ===
# ===
# remove obsolete "use_calibration" option #501
# https://github.com/ildoonet/tf-pose-estimation/pull/501
# tf_pose/estimator.py
sed -i '/use_calibration=True,/d' ./tf_pose/estimator.py
sed -i -e '/try:/itf.compat.v1.disable_eager_execution()' ./tf_pose/estimator.py

cp $SCRIPT_DIR/run_mod.py .
cp $SCRIPT_DIR/run_video_mod.py .
cp $SCRIPT_DIR/run_webcam_mod.py .

# cp run.py run_new.py
# patch -u < diff_run_py.patch
# patch -u run_new.py < $SCRIPT_DIR/diff_run_py.patch
# patching file run_new.py


# --model=cmu
# --model=mobilenet_thin
export MPLBACKEND="agg"
python3 run_mod.py --model=mobilenet_thin --resize=432x368 --image=./images/p1.jpg
python3 run_mod.py --model=mobilenet_thin --resize=432x368 --image=./images/p2.jpg
python3 run_mod.py --model=mobilenet_thin --resize=432x368 --image=./images/p3.jpg
unset MPLBACKEND

ls -l *.png

# python3 run_video_mod.py --model=mobilenet_thin --video=./videos/hoge.mp4 --resolution=432x368

# python3 run_webcam_mod.py --model=mobilenet_thin --resize=432x368 --camera=1


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

