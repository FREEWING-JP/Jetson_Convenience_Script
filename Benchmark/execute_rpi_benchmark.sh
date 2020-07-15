#!/bin/bash


curl -L https://raw.githubusercontent.com/aikoncwd/rpi-benchmark/master/rpi-benchmark.sh | sudo bash

which sysbench
if [ $? -ne 0 ]; then
  sudo apt -y install sysbench
fi

sysbench --test=cpu --threads=1 run

sysbench --test=cpu --threads=$(nproc) run

