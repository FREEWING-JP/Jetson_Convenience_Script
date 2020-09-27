#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/redis-6.0.8 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# Installation Redis
# Redis 6.0 Stable
# Redis 6.0 release notes
# https://raw.githubusercontent.com/redis/redis/6.0/00-RELEASENOTES


# ===
# ===
# Download Redis
cd
# Redis 6.0.8 Released Wed Sep 09 23:34:17 IDT 2020
wget http://download.redis.io/releases/redis-6.0.8.tar.gz


# ===
tar xvfz redis-6.0.8.tar.gz
cd redis-6.0.8


# ===
# Build
echo "Build Redis"
time make -j $(nproc)
#    LINK redis-server
#    LINK redis-benchmark
#    INSTALL redis-sentinel
#    INSTALL redis-check-rdb
#    INSTALL redis-check-aof
#    LINK redis-cli
# Hint: It's a good idea to run 'make test' ;)

# real    1m32.329s
# user    5m6.452s
# sys     0m19.252s


ls -l src/redis-*
# -rwxrwxr-x 1 jetson jetson 5377672 Sep 26 23:44 src/redis-benchmark
# -rwxr-xr-x 1 jetson jetson 9442576 Sep 26 23:44 src/redis-check-aof
# -rwxr-xr-x 1 jetson jetson 9442576 Sep 26 23:44 src/redis-check-rdb
# -rwxrwxr-x 1 jetson jetson 5233440 Sep 26 23:44 src/redis-cli
# -rwxr-xr-x 1 jetson jetson 9442576 Sep 26 23:44 src/redis-sentinel
# -rwxrwxr-x 1 jetson jetson 9442576 Sep 26 23:44 src/redis-server
# -rwxrwxr-x 1 jetson jetson    3600 Sep 10 07:09 src/redis-trib.rb


src/redis-server -v
# Redis server v=6.0.8 sha=00000000:0 malloc=jemalloc-5.1.0 bits=64 build=8a5af1d9f401d038

src/redis-cli -v
# redis-cli 6.0.8


# ===
# You need tcl 8.5 or newer in order to run the Redis test
# Makefile:332: recipe for target 'test' failed
sudo apt install -y tk-dev
# Setting up tk-dev:arm64 (8.6.0+9) ...

# time make test
# \o/ All tests passed without errors!
# Cleanup: may take some time... OK


# ===
# sudo make install


# ===
# The binaries that are now compiled are available in the src directory.
# Run Redis with
# src/redis-server &
# You can interact with Redis using the built-in client:

# src/redis-cli
# redis> set foo bar
# OK
# redis> get foo
# "bar"


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

