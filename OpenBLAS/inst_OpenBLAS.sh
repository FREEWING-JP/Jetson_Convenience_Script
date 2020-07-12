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
# /usr/bin/ld: warning: libopenblas.so.0, needed by /home/jetson/nvcaffe/build/lib/libcaffe-nv.so, not found (try using -rpath or -rpath-link)
# /home/jetson/nvcaffe/build/lib/libcaffe-nv.so: undefined reference to `cblas_sgemv'
# /home/jetson/nvcaffe/build/lib/libcaffe-nv.so: undefined reference to `cblas_sdot'
sudo apt -y install liblapack-dev
# Setting up liblapack-dev:arm64 (3.7.1-4ubuntu1) ...


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

grep " BLAS_.*=" ~/.bashrc
grep "{BLAS_LIB}" ~/.bashrc
grep " .*_NUM_THREADS=" ~/.bashrc

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

