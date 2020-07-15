#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/byte-unixbench ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# Build UnixBench byte-unixbench

# sudo apt-get update
sudo apt-get update

# Do not Install cmake
sudo apt-get -y install git

# ===
cd
git clone https://github.com/kdlucas/byte-unixbench --depth 1
cd byte-unixbench

cp $SCRIPT_DIR/execute_UnixBench.sh .

# Running Benchmarks
chmod +x execute_UnixBench.sh
bash ./execute_UnixBench.sh


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

