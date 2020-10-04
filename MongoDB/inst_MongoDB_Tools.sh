#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# MongoDB Tools
# https://docs.mongodb.com/tools/
# https://www.mongodb.com/try/download/database-tools
# https://github.com/mongodb/mongo-tools
MONGODB_TOOLS_VERSION=$1

if [ "$MONGODB_TOOLS_VERSION" == "" ]; then
  MONGODB_TOOLS_VERSION=master
fi


# Build Tested
# master  2020/09/25 832fb10
# r4.2.10 2020/10/01 1ca852c
# r4.0.20 2020/08/20 39676d8
# r3.6.20 2020/09/11 a7ddcd8
echo MongoDB Tools [$MONGODB_TOOLS_VERSION]


# WARNING: apt-get does not have a stable CLI interface. Use with caution in scripts.
# use "apt-get" in script instead than "apt"


# ===
# Go Programming Language
which go
if [ $? -ne 0 ]; then
  # The Go Programming Language
  sudo apt-get install -y golang
  # Setting up golang (2:1.10~4ubuntu1) ...
fi


go version
# go version go1.10.4 linux/arm64


# GOPATH environment variable
# https://github.com/golang/go/wiki/GOPATH
export GOPATH=$HOME/go
echo $GOPATH
# /home/jetson/go
if [ ! -d $GOPATH ]; then
  mkdir $GOPATH
fi


if [ ! -d $GOPATH/src/github.com/mongodb ]; then
  mkdir -p $GOPATH/src/github.com/mongodb
fi
cd $GOPATH/src/github.com/mongodb

BRANCH=
if [ $MONGODB_TOOLS_VERSION != "" ]; then
  BRANCH="-b $MONGODB_TOOLS_VERSION"
fi


# GOROOT not set and preferred GOROOT '/opt/golang/go1.12' doesn't exist. Aborting.
GO_BIN_PATH=$(readlink -f `which go`)
echo $GO_BIN_PATH
# /usr/lib/go-1.10/bin/go
export GOROOT=$(dirname $(dirname $GO_BIN_PATH))
echo $GOROOT
# /usr/lib/go-1.10
# /usr/lib/go


# Building bsondump...
# runtime/cgo
# fork/exec /opt/mongodbtoolchain/v3/bin/aarch64-mongodb-linux-gcc: no such file or directory
# Error building bsondump

# set CC env.
# set CXX env.
which gcc
# /usr/bin/gcc
which g++
# /usr/bin/g++
CC=`which gcc`
CXX=`which g++`
echo $CC $CXX


# Building mongoreplay...
# # github.com/mongodb/mongo-tools/vendor/github.com/google/gopacket/pcap
# vendor/github.com/google/gopacket/pcap/pcap_unix.go:34:10: fatal error: pcap.h: No such file or directory
#  #include <pcap.h>
#           ^~~~~~~~
# compilation terminated.
# Error building mongoreplay

# pcap.h: No such file or directory
apt list libpcap0.8-dev
if [ $? -ne 0 ]; then
  sudo apt-get install -y libpcap0.8-dev
fi


# Building mongoreplay...
# # github.com/mongodb/mongo-tools/vendor/github.com/10gen/llmgo/internal/sasl
# vendor/github.com/10gen/llmgo/internal/sasl/sasl.go:15:11: fatal error: sasl/sasl.h: No such file or directory
#  // #include <sasl/sasl.h>
#            ^~~~~~~~~~~~~
# compilation terminated.
# Error building mongoreplay

# sasl/sasl.h: No such file or directory
apt list grep libsasl2-dev
if [ $? -ne 0 ]; then
  sudo apt-get install -y libsasl2-dev
fi


echo git clone https://github.com/mongodb/mongo-tools --depth 1 $BRANCH
git clone https://github.com/mongodb/mongo-tools --depth 1 $BRANCH
# https://github.com/mongodb/mongo-tools/
cd mongo-tools

# ./build.sh: 10: ./build.sh: Bad substitution
# ./build.sh: 28: [: Illegal number: /dev/stdin
# #!/bin/sh -> #!/bin/bash
grep '#!/bin/bash' build.sh
if [ $? -ne 0 ]; then
  sed -i 's|#!/bin/sh|#!/bin/bash|' build.sh
fi


# Quick build
env CC=$CC CXX=$CXX ./build.sh ssl sasl


ls -l bin


echo MongoDB Tools [$MONGODB_TOOLS_VERSION]


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

