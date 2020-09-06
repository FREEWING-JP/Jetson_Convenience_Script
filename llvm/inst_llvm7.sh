#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# llvm LLVM_CONFIG
sudo apt-get -y install libllvm-7-ocaml-dev libllvm7 llvm-7 llvm-7-dev llvm-7-doc llvm-7-examples llvm-7-runtime
export LLVM_CONFIG=/usr/bin/llvm-config-7

ls -l $LLVM_CONFIG

# ===
# add LLVM_CONFIG environment variable
echo "export LLVM_CONFIG=${LLVM_CONFIG}" >> ~/.bashrc

