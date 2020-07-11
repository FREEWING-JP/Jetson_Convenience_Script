#!/bin/bash

nvcc --version
if [ $? = 0 ]; then
  echo "OK"
  exit 0
else
  echo ".."
fi

# ===
# add CUDA environment variable
# Jetson Nano nvcc command not found build CUDA app Error
echo '# JetPack nvcc' >> ~/.bashrc
echo 'export CUDA_HOME=/usr/local/cuda' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc
echo 'export PATH=${CUDA_HOME}/bin:${PATH}' >> ~/.bashrc

source ~/.bashrc

