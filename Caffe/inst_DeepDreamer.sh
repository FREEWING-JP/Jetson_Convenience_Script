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


# ===
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


# ===
cp $SCRIPT_DIR/execute_sample.sh .
chmod +x ./execute_sample.sh


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
# Python2 patch
if [ $flag -eq 1 ]; then
  # Python2 patch
  sed '196,198d' -i ./deepdreamer/deepdreamer.py
  # 
  sed '12d' -i ./deepdreamer/deepdreamer.py
fi


# ===
wget https://github.com/google/deepdream/raw/master/flowers.jpg
wget https://github.com/google/deepdream/raw/master/sky1024px.jpg


# ===
PYTHON_COMMAND=python
IS_NVCAFFE=0

# ===
if [ $flag -eq 1 ]; then
  # Python2
  :
else
  # Python3
  PYTHON_COMMAND=python3
fi

${PYTHON_COMMAND} -c "import caffe; print(caffe.__version__)" | grep "^0.17.3"
if [ $? = 0 ]; then
  # NVCaffe 0.17.3
  echo "NVCaffe"
  IS_NVCAFFE=1
fi

sed -i "s/^PYTHON_COMMAND=.*/PYTHON_COMMAND=${PYTHON_COMMAND}/" execute_sample.sh
sed -i "s/^IS_NVCAFFE=.*/IS_NVCAFFE=${IS_NVCAFFE}/" execute_sample.sh


# ===
# execute sample
bash ./execute_sample.sh

