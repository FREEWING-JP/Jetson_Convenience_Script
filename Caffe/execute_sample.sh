#!/bin/sh

# ===
PYTHON_COMMAND=python
IS_NVCAFFE=0

# ===
# Setting the number of threads using environment variables
# The priorities are OPENBLAS_NUM_THREADS > GOTO_NUM_THREADS > OMP_NUM_THREADS .
# https://github.com/xianyi/OpenBLAS
export OPENBLAS_NUM_THREADS=$(nproc)
export GOTO_NUM_THREADS=${OPENBLAS_NUM_THREADS}
export OMP_NUM_THREADS=${OPENBLAS_NUM_THREADS}


# ===
if [ $IS_NVCAFFE -eq 1 ]; then

  echo "NVIDIA Caffe"

  # GPU
  # no need --gpuid
  cp flowers.jpg nv_flowers.jpg
  ${PYTHON_COMMAND} deepdreamer.py --dreams 10 nv_flowers.jpg

  # GPU
  cp sky1024px.jpg nv_sky1024px.jpg
  ${PYTHON_COMMAND} deepdreamer.py --dreams 10 nv_sky1024px.jpg
else

  echo "Caffe"

  # CPU
  ${PYTHON_COMMAND} deepdreamer.py --dreams 10 flowers.jpg

  # GPU
  # optional arguments:
  #   --gpuid GPUID         enable GPU with id GPUID (default: disabled)
  cp flowers.jpg gpu_flowers.jpg
  ${PYTHON_COMMAND} deepdreamer.py --gpuid 0 --dreams 10 gpu_flowers.jpg

  # CPU
  ${PYTHON_COMMAND} deepdreamer.py --dreams 10 sky1024px.jpg

  # GPU
  cp sky1024px.jpg gpu_sky1024px.jpg
  ${PYTHON_COMMAND} deepdreamer.py --gpuid 0 --dreams 10 gpu_sky1024px.jpg

fi

exit 0

