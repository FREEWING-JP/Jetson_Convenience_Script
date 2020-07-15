#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# Benchmarks Targeted for Jetson Xavier NX (Using GPU+2DLA)
# https://github.com/NVIDIA-AI-IOT/jetson_benchmarks
cd
cd jetson_benchmarks

tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  echo "Jetson Xavier NX"

  # Running Benchmarks
  # Running All Benchmark Models at Once
  sudo python3 benchmark.py --all --csv_file_path ./benchmark_csv/nx-benchmarks.csv --model_dir $(pwd)/models

fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  echo "Jetson Nano"

  # Running Benchmarks
  # Running All Benchmark Models at Once on Jetson Nano
  sudo python3 benchmark.py --all --csv_file_path ./benchmark_csv/tx2-nano-benchmarks.csv \
                              --model_dir $(pwd)/models \
                              --jetson_devkit nano \
                              --gpu_freq 921600000 --power_mode 0 --precision fp16

fi


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

