#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# ===
# TensorFlow version
TF_VERSION=`python3 -c "import tensorflow; print (tensorflow.VERSION)"`
if [ $? = 0 ]; then
  echo $TF_VERSION
  if [[ ${TF_VERSION} =~ ^([0-9]+)\..*$ ]]; then
    echo ${BASH_REMATCH[1]}
    if [ ! "${BASH_REMATCH[1]}" = "2" ]; then
      echo "Already Installed TensorFlow v2.x"
      exit 0
    fi
  fi

  echo "Uninstall TensorFlow"
  chmod +x uninstall.sh
  bash ./uninstall.sh
fi


# ===
TF_URL=""

# L4T 32.4.2 = JetPack 4.4
cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 4.2"
# R32 (release), REVISION: 4.2, GCID: 20074772, BOARD: t186ref, EABI: aarch64, DATE: Thu Apr  9 01:26:40 UTC 2020
if [ $? = 0 ]; then
  # L4T 32.4.2 = JetPack 4.4
  echo "JetPack 4.4"
  TF_URL="https://developer.download.nvidia.com/compute/redist/jp/v44"
fi

# L4T 32.3.1 = JetPack 4.3
cat /etc/nv_tegra_release | grep "R32 (release), REVISION: 3.1"
if [ $? = 0 ]; then
  # L4T 32.3.1 = JetPack 4.3
  echo "JetPack 4.3"
  TF_URL="https://developer.download.nvidia.com/compute/redist/jp/v43"
fi

if [ "$TF_URL" = "" ]; then
  echo "Error"
  exit 1
fi

chmod +x sub_TensorFlow_v2.sh
bash ./sub_TensorFlow_v2.sh $TF_URL

cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

