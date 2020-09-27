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


# MongoDB r3.6.8 25e8528 on 25 Oct 2019
# https://docs.mongodb.com/v3.6/installation/
# https://github.com/mongodb/mongo/tree/r3.6.8
# https://github.com/mongodb/mongo/blob/r3.6.8/docs/building.md
MONGO_VERSION=3.6.8
TARGET=core

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
sudo apt install -y python3-pymongo

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
sudo apt install libcurl-dev
# Package libcurl-dev is a virtual package provided by:
#   libcurl4-openssl-dev 7.58.0-2ubuntu3.10
#   libcurl4-nss-dev 7.58.0-2ubuntu3.10
#   libcurl4-gnutls-dev 7.58.0-2ubuntu3.10
sudo apt install -y libcurl4-openssl-dev


cd
# MongoDB r3.4.14 cd0266e on 31 May 2018
git clone https://github.com/mongodb/mongo --depth 1 -b r$MONGO_VERSION
cd mongo


# patch
# error unused variable 'uuid'
# src/mongo/s/commands/cluster_map_reduce_agg.cpp:60:29: error: unused variable 'uuid' [-Werror=unused-variable]
# src/mongo/s/commands/cluster_map_reduce_agg.cpp
#     auto [collationObj, uuid] = sharded_agg_helpers::getCollationAndUUID(
#         routingInfo, nss, parsedMr.getCollation().get_value_or(BSONObj()));
#     (void)uuid;
# -Wno-unused-variable
# https://en.cppreference.com/w/cpp/language/attributes/maybe_unused
# C++17 [[maybe_unused]]
# Note: For C++ compilers that are newer than the supported version, the compiler may issue new warnings that cause MongoDB to fail to build since the build system treats compiler warnings as errors.
# To ignore the warnings, pass the switch --disable-warnings-as-errors to scons.
FILE=src/mongo/s/commands/cluster_map_reduce_agg.cpp
sed -i 's/(BSONObj()));/(BSONObj())); (void)uuid;/' $FILE

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


# SCons Targets
# mongod
# mongos
# mongo
# core (includes mongod, mongos, mongo)
# all
# TARGET=core
# MONGO_VERSION=3.6.8
# none --disable-warnings-as-errors
time python3 buildscripts/scons.py $TARGET MONGO_VERSION=$MONGO_VERSION CFLAGS="-march=armv8-a+crc -mtune=generic"


ls -l mongo*


./mongo --version

./mongod --version

./mongos --version


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

