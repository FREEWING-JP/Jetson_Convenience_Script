cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/mongo ]; then
  echo "Already Exists Directory"
  exit 0
fi


# MongoDB r4.4.1
# https://docs.mongodb.com/v4.4/installation/
# https://github.com/mongodb/mongo/tree/r4.4.1
# https://github.com/mongodb/mongo/blob/r4.4.1/docs/building.md
MONGO_VERSION=4.4.1
TARGET=install-core

echo MongoDB r$MONGO_VERSION
echo TARGET $TARGET


python3 -V
# Python 3.6.9

# Install pip3
sudo apt install -y python3-pip
# Setting up python3-pip (9.0.1-2.3~ubuntu1.18.04.2) ...

# Debian / Ubuntu
# To install dependencies on Debian or Ubuntu systems
sudo apt install -y scons build-essential
# Setting up scons (3.0.1-1) ...

scons -h

scons -v
# SCons by Steven Knight et al.:
#         script: v3.0.1.74b2c53bc42290e911b334a6b44f187da698a668, 2017/11/14 13:16:53, by bdbaddog on hpmicrodog
#         engine: v3.0.1.74b2c53bc42290e911b334a6b44f187da698a668, 2017/11/14 13:16:53, by bdbaddog on hpmicrodog
#         engine path: ['/usr/lib/scons/SCons']
# Copyright (c) 2001 - 2017 The SCons Foundation

sudo apt install -y libboost-filesystem-dev libboost-program-options-dev libboost-system-dev libboost-thread-dev

# To run tests as well , you will need PyMongo
# sudo apt install -y python3-pymongo

# Then build as usual with scons
# scons all


# GCC 8.0 or newer
# Checking if C compiler is GCC 8.2 or newer...no
# Checking if C++ compiler is GCC 8.2 or newer...no
# ERROR: Refusing to build with compiler that does not meet requirements
# See /home/jetson/mongo/build/scons/config.log for details
sudo apt install -y gcc-8 g++-8
# gcc-8 (Ubuntu/Linaro 8.4.0-1ubuntu1~18.04) 8.4.0


# enable gcc-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 700 --slave /usr/bin/g++ g++ /usr/bin/g++-7
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
# sudo update-alternatives --config gcc
# update-alternatives --set
# update-alternatives: --set needs <name> <path>

# enable gcc-8
sudo update-alternatives --auto gcc


# libcurl library
# Checking for curl_global_init(0) in C library curl... no
# Could not find <curl/curl.h> and curl lib
# See /home/jetson/mongo/build/scons/config.log for details
sudo apt install libcurl-dev
# Package libcurl-dev is a virtual package provided by:
#   libcurl4-openssl-dev 7.58.0-2ubuntu3.10
#   libcurl4-nss-dev 7.58.0-2ubuntu3.10
#   libcurl4-gnutls-dev 7.58.0-2ubuntu3.10
sudo apt install -y libcurl4-openssl-dev

# Couldn't find OpenSSL crypto.h header and library
sudo apt install -y libssl-dev


cd
# MongoDB r4.4.1
git clone https://github.com/mongodb/mongo --depth 1 -b r$MONGO_VERSION
cd mongo


# ModuleNotFoundError: No module named 'Cheetah'
# Python Prerequisites
python3 -m pip install -r etc/pip/compile-requirements.txt


# scons: Reading SConscript files ...
# ModuleNotFoundError: No module named 'psutil':
# File "/home/jetson/mongo/SConstruct", line 46:
# import psutil
# psutil Cross-platform lib for process and system monitoring in Python.
# https://pypi.org/project/psutil/
# pip3 install psutil==5.6.3
# psutil 5.6.3 Jun 11, 2019


# patch

# CRC armv8-a+crc
# Add ARM8 build support to WiredTiger and fix ARM CRC assembler tags
# https://jira.mongodb.org/browse/WT-2900
# https://github.com/mongodb/mongo/blob/39d650faa5436a37359ca45717d5e988fb4461cb/etc/evergreen.yml#L3881
# https://gcc.gnu.org/onlinedocs/gcc-5.4.0/gcc/ARM-Options.html#ARM-Options
# Compiling build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o
# /tmp/ccFk9ZFj.s: Assembler messages:
# /tmp/ccFk9ZFj.s:41: Error: selected processor does not support `crc32cb w2,w2,w3'
# /tmp/ccFk9ZFj.s:73: Error: selected processor does not support `crc32cx w2,w2,x4'
# /tmp/ccFk9ZFj.s:101: Error: selected processor does not support `crc32cb w2,w2,w0'
# scons: *** [build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o] Error 1
# scons: building terminated because of errors.
# build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o failed: Error 1
# CFLAGS="-march=armv8-a+crc -mtune=generic"


# SCons Targets
# mongod
# mongos
# mongo
# core (includes mongod, mongos, mongo)
# all
# TARGET=core
# MONGO_VERSION=4.4.1
# none --disable-warnings-as-errors
time python3 buildscripts/scons.py $TARGET MONGO_VERSION=$MONGO_VERSION CFLAGS="-march=armv8-a+crc -mtune=generic"

# Install file: "build/opt/mongo/mongod" as "build/install/bin/mongod"
# Linking build/opt/mongo/mongos
# Install file: "build/opt/mongo/mongos" as "build/install/bin/mongos"
# scons: done building targets.

# Jetson Xavier NX
# real    213m15.334s
# user    1056m52.828s
# sys     41m33.304s


ls -l ./build/opt/mongo/mongo*
# -rwxrwxr-x 1 jetson jetson 1206316912 Sep 28 07:41 ./build/opt/mongo/mongo
# -rwxrwxr-x 1 jetson jetson 3134961152 Sep 28 07:58 ./build/opt/mongo/mongod
# -rwxrwxr-x 1 jetson jetson 2038326728 Sep 28 08:08 ./build/opt/mongo/mongos

ls -l ./build/install/bin/mongo*
# -rwxrwxr-x 1 jetson jetson 1206316912 Sep 28 07:41 ./build/install/bin/mongo
# -rwxrwxr-x 1 jetson jetson 3134961152 Sep 28 07:58 ./build/install/bin/mongod
# -rwxrwxr-x 1 jetson jetson 2038326728 Sep 28 08:08 ./build/install/bin/mongos


./build/opt/mongo/mongo --version
MongoDB shell version v4.4.1
# Build Info: {
#     "version": "4.4.1",
#     "gitVersion": "ad91a93a5a31e175f5cbf8c69561e788bbc55ce1",
#     "openSSLVersion": "OpenSSL 1.1.1  11 Sep 2018",
#     "modules": [],
#     "allocator": "tcmalloc",
#     "environment": {
#         "distarch": "aarch64",
#         "target_arch": "aarch64"
#     }
# }

./build/opt/mongo/mongod --version
# db version v4.4.1
# Build Info: {
#     "version": "4.4.1",
#     "gitVersion": "ad91a93a5a31e175f5cbf8c69561e788bbc55ce1",
#     "openSSLVersion": "OpenSSL 1.1.1  11 Sep 2018",
#     "modules": [],
#     "allocator": "tcmalloc",
#     "environment": {
#         "distarch": "aarch64",
#         "target_arch": "aarch64"
#     }
# }

./build/opt/mongo/mongos --version
# mongos version v4.4.1
# Build Info: {
#     "version": "4.4.1",
#     "gitVersion": "ad91a93a5a31e175f5cbf8c69561e788bbc55ce1",
#     "openSSLVersion": "OpenSSL 1.1.1  11 Sep 2018",
#     "modules": [],
#     "allocator": "tcmalloc",
#     "environment": {
#         "distarch": "aarch64",
#         "target_arch": "aarch64"
#     }
# }


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

