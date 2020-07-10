#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/nvffmpeg ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===
tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
echo $tegra_cip_id

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  chmod +x ./sub_NV_FFmpeg_XV.sh
  bash ./sub_NV_FFmpeg_XV.sh
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  chmod +x ./sub_NV_FFmpeg_Nano.sh
  bash ./sub_NV_FFmpeg_Nano.sh
fi


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

