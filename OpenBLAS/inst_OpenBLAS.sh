#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/OpenBLAS ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
# OpenBLAS v0.3.10
# OpenBLAS develop
# https://github.com/xianyi/OpenBLAS
cd
git clone https://github.com/xianyi/OpenBLAS --depth 1 -b develop
cd OpenBLAS


# ===
# compiled with threading support
time make USE_THREAD=1
#  OpenBLAS build complete. (BLAS CBLAS)
#   OS               ... Linux
#   Architecture     ... arm64
#   BINARY           ... 64bit
#   C compiler       ... GCC  (cmd & version : cc (Ubuntu/Linaro 7.4.0-1ubuntu1~18.04.1) 7.4.0)
#   Library Name     ... libopenblas_armv8p-r0.3.10.dev.a (Multi-threading; Max num-threads is 6)
# 
# To install the library, you can run "make PREFIX=/path/to/your/installation install".


# ===
sudo make install
sudo ldconfig
# Generating openblas_config.h in /opt/OpenBLAS/include
# Generating f77blas.h in /opt/OpenBLAS/include
# Generating cblas.h in /opt/OpenBLAS/include
# Copying the static library to /opt/OpenBLAS/lib
# Copying the shared library to /opt/OpenBLAS/lib
# Generating openblas.pc in /opt/OpenBLAS/lib/pkgconfig
# Generating OpenBLASConfig.cmake in /opt/OpenBLAS/lib/cmake/openblas
# Generating OpenBLASConfigVersion.cmake in /opt/OpenBLAS/lib/cmake/openblas
echo '# OpenBLAS' >> ~/.bashrc
echo 'export BLAS_INCLUDE=/opt/OpenBLAS/include' >> ~/.bashrc
echo 'export BLAS_LIB=/opt/OpenBLAS/lib' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${BLAS_LIB}:$LD_LIBRARY_PATH' >> ~/.bashrc

echo 'export OPENBLAS_NUM_THREADS=$(nproc)' >> ~/.bashrc
echo 'export GOTO_NUM_THREADS=${OPENBLAS_NUM_THREADS}' >> ~/.bashrc
echo 'export OMP_NUM_THREADS=${OPENBLAS_NUM_THREADS}' >> ~/.bashrc

source ~/.bashrc

set | grep "BLAS_.*="
set | grep "LD_LIBRARY_PATH="
set | grep ".*_NUM_THREADS="

# ===
echo '---'
echo "type 'source ~/.bashrc'"
echo ''
echo "source ~/.bashrc"


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi
