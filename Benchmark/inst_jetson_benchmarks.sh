#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
if [ -d ~/jetson_benchmarks ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# Benchmarks Targeted for Jetson Xavier NX (Using GPU+2DLA)
# https://github.com/NVIDIA-AI-IOT/jetson_benchmarks
cd
git clone https://github.com/NVIDIA-AI-IOT/jetson_benchmarks.git
cd jetson_benchmarks
# Open folder to store models (Optional)
mkdir models


cp $SCRIPT_DIR/execute_jetson_benchmarks.sh .


# Install Requirements
sudo sh install_requirements.sh


# input("Please close all other applications and Press Enter to continue...")
sed -i 's/system_check.close_all_apps()/# system_check.close_all_apps()/' benchmark.py

tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  echo "Jetson Xavier NX"

  # Jetson Xavier NX
  # Download Models
  python3 utils/download_models.py --all --csv_file_path ./benchmark_csv/nx-benchmarks.csv --save_dir $(pwd)/models

fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  echo "Jetson Nano"

  # Jetson Nano
  # Download Models
  python3 utils/download_models.py --all --csv_file_path ./benchmark_csv/tx2-nano-benchmarks.csv --save_dir $(pwd)/models

fi


# Running Benchmarks
chmod +x execute_jetson_benchmarks.sh
bash ./execute_jetson_benchmarks.sh


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

