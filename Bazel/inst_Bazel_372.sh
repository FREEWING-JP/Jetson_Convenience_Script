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


# Bazel Release 3.7.2 (2020-12-17)
# https://bazel.build/
# https://github.com/bazelbuild/bazel/tree/3.7.2
# https://docs.bazel.build/versions/master/install-compile-source.html
BAZEL_VERSION=3.7.2
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
if [ $? -ne 0 ]; then
  echo "ERROR Could not build Bazel"
  exit 0
fi
END=`date`
echo $START - $END

# Jetson Xavier NX
# Build successful! Binary is here: /home/jetson/bazel/output/bazel
# real    16m50.887s
# user    70m37.692s
# sys     3m13.492s

ls -l ./output/bazel
# -rwxr-xr-x 1 jetson jetson 27165164 Mar  4 07:32 ./output/bazel


./output/bazel help


./output/bazel version
# Build label: 3.7.2- (@non-git)
# Build target: bazel-out/aarch64-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
# Build time: Thu Mar 4 12:19:04 2021 (1614860344)
# Build timestamp: 1614860344
# Build timestamp as int: 1614860344

echo $START - $END


sudo cp ./output/bazel /usr/local/bin/
cd
bazel version


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

