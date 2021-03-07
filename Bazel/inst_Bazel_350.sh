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


# Bazel Release 3.5.0 (2020-09-02)
# https://bazel.build/
# https://github.com/bazelbuild/bazel/tree/3.5.0
# https://docs.bazel.build/versions/master/install-compile-source.html
BAZEL_VERSION=3.5.0

echo Bazel $BAZEL_VERSION


# bazelbuild / bazel
# Compiling Bazel from source

# Build Bazel from scratch (bootstrapping)
# Release 3.5.0 (2020-09-02)
# Step 1: Download Bazel's sources (distribution archive)
cd
wget https://github.com/bazelbuild/bazel/releases/download/3.5.0/bazel-3.5.0-dist.zip

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


unzip bazel-3.5.0-dist.zip -d bazel
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


ls -l ./output/bazel
# -rwxr-xr-x 1 jetson jetson 26956176 Sep 28 11:10 ./output/bazel


./output/bazel help


./output/bazel version
# Build label: 3.5.0- (@non-git)
# Build target: bazel-out/aarch64-opt/bin/src/main/java/com/google/devtools/build/lib/bazel/BazelServer_deploy.jar
# Build time: Mon Sep 28 14:52:50 2020 (1601304770)
# Build timestamp: 1601304770
# Build timestamp as int: 1601304770

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

