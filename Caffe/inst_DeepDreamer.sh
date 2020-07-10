#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/deepdreamer ]; then
  echo "Already Exists Directory"
  exit 0
fi


echo ${CAFFE_HOME}
if [ "${CAFFE_HOME}" = "" ]; then
  echo "no CAFFE_HOME env."
  exit 1
fi


flag=0
python -c "import caffe; print(caffe.__version__)"
if [ $? = 0 ]; then
  echo "Detect Python2 Caffe"
  flag=1
fi

python3 -c "import caffe; print(caffe.__version__)"
if [ $? = 0 ]; then
  echo "Detect Python3 Caffe"
  flag=$(( $flag+2 ))
fi

if [ $flag -eq 0 ]; then
  echo "No Python module Caffe"
  exit 1
fi


# ===
# ===
# Deep Dream kesara/deepdreamer Git clone
cd
git clone https://github.com/kesara/deepdreamer --depth 1
cd deepdreamer

# bvlc_googlenet.caffemodel
wget http://dl.caffe.berkeleyvision.org/bvlc_googlenet.caffemodel

# deploy.prototxt
# https://github.com/BVLC/caffe/tree/master/models/bvlc_googlenet
wget https://raw.githubusercontent.com/BVLC/caffe/master/models/bvlc_googlenet/deploy.prototxt

# force_backward: true
echo "force_backward: true" >> deploy.prototxt

# tail
tail deploy.prototxt


# ===
# Python2 only
if [ $flag -eq 1 ]; then
  # Python2 patch
  sed '196,198d' -i ./deepdreamer/deepdreamer.py
  # 
  sed '12d' -i ./deepdreamer/deepdreamer.py
fi


# ===
# Setting the number of threads using environment variables
# The priorities are OPENBLAS_NUM_THREADS > GOTO_NUM_THREADS > OMP_NUM_THREADS .
# https://github.com/xianyi/OpenBLAS
export OPENBLAS_NUM_THREADS=$(nproc)
export GOTO_NUM_THREADS=${OPENBLAS_NUM_THREADS}
export OMP_NUM_THREADS=${OPENBLAS_NUM_THREADS}


# ===
wget https://github.com/google/deepdream/raw/master/flowers.jpg
wget https://github.com/google/deepdream/raw/master/sky1024px.jpg


# ===
if [ $flag -eq 1 ]; then
  # Python2 only

  python -c "import caffe; print(caffe.__version__)" | grep "^0.17.3"
  if [ $? = 0 ]; then
    # NVCaffe 0.17.3
    echo "NVCaffe"

    # GPU
    # no need --gpuid
    cp flowers.jpg nv_flowers.jpg
    python deepdreamer.py --dreams 10 nv_flowers.jpg

    # GPU
    cp sky1024px.jpg nv_sky1024px.jpg
    python deepdreamer.py --dreams 10 nv_sky1024px.jpg
  else

    echo "Caffe"

    # CPU
    python deepdreamer.py --dreams 10 flowers.jpg

    # GPU
    # optional arguments:
    #   --gpuid GPUID         enable GPU with id GPUID (default: disabled)
    cp flowers.jpg gpu_flowers.jpg
    python deepdreamer.py --gpuid 0 --dreams 10 gpu_flowers.jpg

    # CPU
    python deepdreamer.py --dreams 10 sky1024px.jpg

    # GPU
    cp sky1024px.jpg gpu_sky1024px.jpg
    python deepdreamer.py --gpuid 0 --dreams 10 gpu_sky1024px.jpg

  fi

else
  # Python3

  python3 -c "import caffe; print(caffe.__version__)" | grep "^0.17.3"
  if [ $? = 0 ]; then
    # NVCaffe 0.17.3
    echo "NVCaffe OpenCV 4.x"

    # GPU
    # no need --gpuid
    cp flowers.jpg nv_flowers.jpg
    python3 deepdreamer.py --dreams 10 nv_flowers.jpg

    # GPU
    cp sky1024px.jpg nv_sky1024px.jpg
    python3 deepdreamer.py --dreams 10 nv_sky1024px.jpg
  else

    echo "Qengineering Caffe OpenCV 4.x"

    # CPU
    python3 deepdreamer.py --dreams 10 flowers.jpg

    # GPU
    # optional arguments:
    #   --gpuid GPUID         enable GPU with id GPUID (default: disabled)
    cp flowers.jpg gpu_flowers.jpg
    python3 deepdreamer.py --gpuid 0 --dreams 10 gpu_flowers.jpg

    # CPU
    python3 deepdreamer.py --dreams 10 sky1024px.jpg

    # GPU
    cp sky1024px.jpg gpu_sky1024px.jpg
    python3 deepdreamer.py --gpuid 0 --dreams 10 gpu_sky1024px.jpg

  fi

fi

exit 0

