#!/bin/bash

grep "^export OPENBLAS_NUM_THREADS" ~/.bashrc
if [ $? -ne 0 ]; then
  echo '# OpenBLAS' >> ~/.bashrc
  echo 'export OPENBLAS_NUM_THREADS=$(nproc)' >> ~/.bashrc
  echo 'export GOTO_NUM_THREADS=${OPENBLAS_NUM_THREADS}' >> ~/.bashrc
  echo 'export OMP_NUM_THREADS=${OPENBLAS_NUM_THREADS}' >> ~/.bashrc
fi

source ~/.bashrc

