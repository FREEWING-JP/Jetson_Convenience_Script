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


# MongoDB r3.4.14 cd0266e on 31 May 2018
# https://docs.mongodb.com/v3.4/installation/
# https://github.com/mongodb/mongo/tree/r3.4.14
# https://github.com/mongodb/mongo/blob/r3.4.14/docs/building.md
MONGO_VERSION=3.4.14
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


cd
# MongoDB r3.4.14 cd0266e on 31 May 2018
git clone https://github.com/mongodb/mongo --depth 1 -b r$MONGO_VERSION
cd mongo


# patch
# src/third_party/boost-1.60.0/boost/function/function_base.hpp:308:13: error: placement new constructing an object of type 'boost::detail::function::functor_manager_common<boost::algorithm::detail::first_finderF<const char*, boost::algorithm::is_iequal> >::functor_type {aka boost::algorithm::detail::first_finderF<const char*, boost::algorithm::is_iequal>}' and size '24' in a region of type 'char' and size '1' [-Werror=placement-new=]
ls -l src/third_party/boost-1.60.0/boost/function/function_base.hpp
# -rw-rw-r-- 1 jetson jetson 31308 Sep 27 02:22 src/third_party/boost-1.60.0/boost/function/function_base.hpp

# placement new issues with gcc6 #85
# https://github.com/cpp-netlib/uri/issues/85
# ddurham2 commented on 22 Sep 2016
FILE=src/third_party/boost-1.60.0/boost/function/function_base.hpp
sed -i "s/To relax aliasing constraints/To relax aliasing constraints (HACK - I\'m making data at least as big as the things above to avoid a placement-new error we\'re getting with gcc6.  Not sure if that makes this comment now irrelevant)/" $FILE
sed -i 's/mutable char data;/mutable char data[sizeof(bound_memfunc_ptr_t)];/' $FILE


# src/mongo/util/scopeguard.h:154:7: error: mangled name for 'mongo::ScopeGuardImpl1<int (*)(pthread_attr_t*) throw (), pthread_attr_t*>::ScopeGuardImpl1(const mongo::ScopeGuardImpl1<int (*)(pthread_attr_t*) throw (), pthread_attr_t*>&)' will change in C++17 because the exception specification is part of a function type [-Werror=noexcept-type]
#  class ScopeGuardImpl1 : public ScopeGuardImplBase {
#        ^~~~~~~~~~~~~~~
# Mongo build failure [-Werror=noexcept-type]
# https://jira.mongodb.org/browse/SERVER-30711
# You can downgrade it again to a warning by building with --disable-warnings-as-errors .

# CRC armv8-a+crc
# Add ARM8 build support to WiredTiger and fix ARM CRC assembler tags
# https://jira.mongodb.org/browse/WT-2900
# https://github.com/mongodb/mongo/blob/39d650faa5436a37359ca45717d5e988fb4461cb/etc/evergreen.yml#L3881
# https://gcc.gnu.org/onlinedocs/gcc-5.4.0/gcc/ARM-Options.html#ARM-Options
# Compiling build/opt/third_party/wiredtiger/src/checksum/arm64/crc32-arm64.o
# /tmp/ccN6LZ2a.s: Assembler messages:
# /tmp/ccN6LZ2a.s:35: Error: selected processor does not support `crc32cb w2,w2,w3'
# /tmp/ccN6LZ2a.s:59: Error: selected processor does not support `crc32cx w2,w2,x4'
# /tmp/ccN6LZ2a.s:79: Error: selected processor does not support `crc32cb w2,w2,w0'
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
# MONGO_VERSION=3.4.14
time scons $TARGET MONGO_VERSION=$MONGO_VERSION --disable-warnings-as-errors CFLAGS="-march=armv8-a+crc -mtune=generic"


ls -l mongo*
# -rwxrwxr-x 1 jetson jetson 266081960 Sep 27 07:43 mongo
# -rwxrwxr-x 1 jetson jetson 704952504 Sep 27 07:49 mongod
# -rwxrwxr-x 1 jetson jetson 358411840 Sep 27 08:10 mongos


./mongo --version
# MongoDB shell version v3.4.14
# git version: cd0266e8c63dae2722487c434d8a524b62a8a619
# allocator: tcmalloc
# modules: none
# build environment:
#     distarch: aarch64
#     target_arch: aarch64

./mongod --version
# db version v3.4.14
# git version: cd0266e8c63dae2722487c434d8a524b62a8a619

./mongos --version
# mongos version v3.4.14
# git version: cd0266e8c63dae2722487c434d8a524b62a8a619


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

