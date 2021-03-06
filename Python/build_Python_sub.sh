#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===

PYTHON_VERSION=$1
echo $PYTHON_VERSION


sudo apt-get -y install \
    build-essential \
    gdb \
    lcov \
    libbz2-dev \
    libdb++-dev \
    libdb-dev \
    libffi-dev \
    libgdbm-dev \
    libgdm-dev \
    liblzma-dev \
    libncurses-dev \
    libnss3-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    llvm \
    lzma \
    lzma-dev \
    tk-dev \
    uuid-dev \
    xvfb \
    xz-utils \
    zlib1g-dev


cd
git clone https://github.com/python/cpython -b $PYTHON_VERSION --depth 1
cd cpython


./configure --enable-optimizations
time make -j$(nproc)

{2}# Jetson Xavier NX
# real    81m21.656s
# user    87m34.696s
# sys     2m19.628s


sudo make install

which python3
if [ $? -eq 0 ]; then
  python3 -V
fi

which python3.6
if [ $? -eq 0 ]; then
  python3.6 -V
fi

which python3.7
if [ $? -eq 0 ]; then
  python3.7 -V
fi

which python3.8
if [ $? -eq 0 ]; then
  python3.8 -V
fi

which python3.9
if [ $? -eq 0 ]; then
  python3.9 -V
fi


# ===
echo '---'
echo "type 'sudo reboot"
echo ''
echo "sudo reboot"


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

