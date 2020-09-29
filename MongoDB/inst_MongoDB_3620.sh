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


# MongoDB r3.6.20 39c2008 on 11 Sep 2020
# https://docs.mongodb.com/v3.6/installation/
# https://github.com/mongodb/mongo/tree/r3.6.20
# https://github.com/mongodb/mongo/blob/r3.6.20/docs/building.md
MONGO_VERSION=3.6.20
TARGET=core

echo MongoDB r$MONGO_VERSION
echo TARGET $TARGET


# This version of MongoDB can only be built with Python 2.7 you appear to be using version: 3.6.9 (default, Jul 17 2020, 12:50:27)

python -V
# Python 2.7.17


# Install pip
sudo apt install -y python-pip
# Setting up python-pip (9.0.1-2.3~ubuntu1.18.04.2) ...

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
# sudo apt install -y python-pymongo

# Then build as usual with scons
# scons all


# GCC 5.4.0 or newer


# libcurl library
sudo apt install libcurl-dev
# Package libcurl-dev is a virtual package provided by:
#   libcurl4-openssl-dev 7.58.0-2ubuntu3.10
#   libcurl4-nss-dev 7.58.0-2ubuntu3.10
#   libcurl4-gnutls-dev 7.58.0-2ubuntu3.10
sudo apt install -y libcurl4-openssl-dev


cd
# MongoDB r3.6.20 39c2008 on 11 Sep 2020
git clone https://github.com/mongodb/mongo --depth 1 -b r$MONGO_VERSION
cd mongo


# Failed building wheel for cffi
# building '_cffi_backend' extension
# c/_cffi_backend.c:15:10: fatal error: ffi.h: No such file or directory
# #include <ffi.h>
sudo apt install -y libffi-dev
# Setting up libffi-dev:arm64 (3.2.1-8) ...

# Failed building wheel for cryptography
# building '_openssl' extension
#  build/temp.linux-aarch64-2.7/_openssl.c:575:10: fatal error: openssl/opensslv.h: No such file or directory
# #include <openssl/opensslv.h>
sudo apt install -y libssl-dev


# ImportError: No module named Cheetah.Template
# Python Prerequisites
python2.7 -m pip install -r buildscripts/requirements.txt

# patch

# CRC armv8-a+crc
# Add ARM8 build support to WiredTiger and fix ARM CRC assembler tags
# https://jira.mongodb.org/browse/WT-2900
# https://github.com/mongodb/mongo/blob/39d650faa5436a37359ca45717d5e988fb4461cb/etc/evergreen.yml#L3881
# https://gcc.gnu.org/onlinedocs/gcc-5.4.0/gcc/ARM-Options.html#ARM-Options
# Compiling build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o
# /tmp/cc49PuvW.s: Assembler messages:
# /tmp/cc49PuvW.s:41: Error: selected processor does not support `crc32cb w2,w2,w3'
# /tmp/cc49PuvW.s:73: Error: selected processor does not support `crc32cx w2,w2,x4'
# /tmp/cc49PuvW.s:101: Error: selected processor does not support `crc32cb w2,w2,w0'
# scons: *** [build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o] Error 1
# scons: building terminated because of errors.
# build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o failed: Error 1
# CFLAGS="-march=armv8-a+crc -mtune=generic"

# MongoDB 3.4.4 fails to build with gcc 7
# https://jira.mongodb.org/browse/SERVER-29335
# src/mongo/util/time_support.cpp:200:6: error: '__builtin___snprintf_chk' output may be truncated before the last format character [-Werror=format-truncation=]
# void _dateToCtimeString(Date_t date, DateStringBuffer* result) {
# /usr/include/aarch64-linux-gnu/bits/stdio2.h:65:44: note: '__builtin___snprintf_chk' output between 5 and 6 bytes into a destination of size 5
# --disable-warnings-as-errors


# SCons Targets
# mongod
# mongos
# mongo
# core (includes mongod, mongos, mongo)
# all
# TARGET=core
# MONGO_VERSION=3.6.20
time python2.7 buildscripts/scons.py $TARGET MONGO_VERSION=$MONGO_VERSION --disable-warnings-as-errors CFLAGS="-march=armv8-a+crc -mtune=generic"

# Jetson Xavier NX
# real    90m8.297s
# user    472m58.076s
# sys     20m28.044s

# Jetson Nano
# real    118m15.498s
# user    428m11.560s
# sys     23m35.528s


# Jetson Xavier NX
ls -l mongo*
# -rwxrwxr-x 1 jetson jetson  535738736 Sep 28 09:46 mongo
# -rwxrwxr-x 1 jetson jetson 1331398984 Sep 28 09:48 mongod
# -rwxrwxr-x 1 jetson jetson  694476744 Sep 28 09:04 mongos

# Jetson Nano
# -rwxrwxr-x 1 jetson jetson  376122128 Sep 27 09:50 mongo
# -rwxrwxr-x 1 jetson jetson  981337960 Sep 27 10:23 mongod
# -rwxrwxr-x 1 jetson jetson  500196072 Sep 27 09:44 mongos


./mongo --version
# MongoDB shell version v3.6.20
# git version: 39c200878284912f19553901a6fea4b31531a899
# allocator: tcmalloc
# modules: none
# build environment:
#     distarch: aarch64
#     target_arch: aarch64

./mongod --version
# db version v3.6.20
# git version: 39c200878284912f19553901a6fea4b31531a899

./mongos --version
# mongos version v3.6.20
# git version: 39c200878284912f19553901a6fea4b31531a899


# To install
# python2.7 buildscripts/scons.py --prefix=/opt/mongo install


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

