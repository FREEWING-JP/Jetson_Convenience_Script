#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/memcached ]; then
  echo "Already Exists Directory"
  exit 0
fi


# https://github.com/memcached/memcached/blob/master/BUILD
# Build Memcached instructions

# ===
# Memcached dependencies
echo "Memcached dependencies"
# To build memcached in your machine from local repo you will have to install
# autotools, automake and libevent.
# In a debian based system that will look like this
sudo apt-get install -y autotools-dev
# autotools-dev is already the newest version (20180224.1).
sudo apt-get install -y automake
# automake is already the newest version (1:1.15.1-3ubuntu2).

# ./configure
# checking for libevent directory... configure: error: libevent is required.
# You can get it from https://www.monkey.org/~provos/libevent/
# If it's already installed, specify its path using --with-libevent=/dir/
sudo apt-get install -y libevent-dev
# Setting up libevent-core-2.1-6:arm64 (2.1.8-stable-4build1) ...


# ===
# ===
# Memcached Git clone
cd
# 2020/09/05 ad8dfd2 1.6.7
git clone https://github.com/memcached/memcached.git --depth 1 -b 1.6.7


# ===
# Build
echo "Build Memcached"
# After that you can build memcached binary using automake
cd memcached
./autogen.sh

./configure

time make -j $(nproc)
# real    0m41.393s
# user    0m55.312s
# sys     0m4.200s

ls -l memcached
# -rwxrwxr-x 1 jetson jetson 1088560 Sep 26 01:27 memcached

./memcached --version
# memcached 1.6.7

# ===
# time make test


# ===
# sudo make install


# ===
# It should create the binary in the same folder, which you can run
# cd
# ./memcached &

# You can telnet into that memcached to ensure it is up and running
# sudo apt install -y telnet
# telnet 127.0.0.1 11211
# Connected to 127.0.0.1.
# stats
# STAT pid 13866
# STAT uptime 11
# STAT time 1601186089
# ...
# STAT direct_reclaims 0
# STAT lru_bumps_dropped 0
# END
# quit
# Connection closed by foreign host.


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

