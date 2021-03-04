#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/bazel ]; then
  echo "Already Exists Directory"
  exit 0
fi


sudo echo


# Bazel Release 4.0.0 (2021-01-21)
# https://bazel.build/
# https://github.com/bazelbuild/bazel/
# https://docs.bazel.build/versions/master/install-compile-source.html
BAZEL_VERSION=4.0.0
BAZEL_ZIP=bazel-$BAZEL_VERSION-dist.zip

echo Bazel $BAZEL_VERSION


# bazelbuild / bazel
# Compiling Bazel from source

# Build Bazel from scratch (bootstrapping)
# Step 1: Download Bazel's sources (distribution archive)
cd
wget https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/$BAZEL_ZIP

# Step 2a: Bootstrap Bazel on Ubuntu Linux, macOS, and other Unix-like systems
# 2.1. Install the prerequisites
# Bash
# zip, unzip
# C++ build toolchain
# JDK. Versions 8 and 11 are supported.
# Python. Versions 2 and 3 are supported, installing one of them is enough.
sudo apt-get install -y python zip unzip
# Bazel needs a C++ compiler and unzip / zip in order to work:
sudo apt-get install -y pkg-config zip g++ zlib1g-dev build-essential
# Ubuntu 18.04 (LTS) uses OpenJDK 11 by default:
sudo apt-get install -y openjdk-11-jdk


unzip $BAZEL_ZIP -d bazel
cd bazel


# 2.2. Bootstrap Bazel
START=`date`
time env EXTRA_BAZEL_ARGS="--host_javabase=@local_jdk//:jdk" bash ./compile.sh
END=`date`
echo $START - $END


ls -l ./output/bazel
# -rwxr-xr-x 1 jetson jetson 28670577 Jan 29 22:47 ./output/bazel


./output/bazel help


./output/bazel version
# Build label: 4.0.0- (@non-git)
# Build target: bazel-out/aarch64-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
# Build time: Sat Jan 30 03:25:13 2021 (1611977113)
# Build timestamp: 1611977113
# Build timestamp as int: 1611977113

echo $START - $END

# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

