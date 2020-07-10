#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/vscode ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# ===

chmod +x dependencies.sh
bash ./dependencies.sh


# Git clone vscode 1.35.0
# Only 1.35.0 version of Visual Studio Code, Jetson Nano builds successfully
cd
git clone https://github.com/Microsoft/vscode.git -b 1.35.0 --depth 1
# Note: checking out '553cfb2c2205db5f15f3ee8395bbd5cf066d357d'.

cd vscode

# Jetson Nano patch
# --max_old_space_size=2048
cat package.json | grep 4095
#     "compile": "gulp compile --max_old_space_size=4095",
#     "watch": "gulp watch --max_old_space_size=4095",
#     "watch-client": "gulp watch-client --max_old_space_size=4095",
#     "gulp": "gulp --max_old_space_size=4095",

cat package.json | grep 8192

# --max_old_space_size=2048
sed -i 's/4095/2048/g' package.json


# 1st yarn
yarn
if [ $? = 0 ]; then
  echo "OK"
else
  # 2nd yarn
  yarn
  if [ $? = 0 ]; then
    echo "OK"
  else
    # 3rd yarn
    yarn
    if [ $? = 0 ]; then
      echo "OK"
    else
      echo "=========="
      echo "=== NG ==="
      echo "=========="
      exit
    fi
  fi
fi


# Make DEB package
yarn run gulp vscode-linux-arm64-min
yarn run gulp vscode-linux-arm64-build-deb

# Install from DEB package
sudo dpkg -i ./.build/linux/deb/arm64/deb/code-oss_1.35.0-*_arm64.deb

code-oss -v
# 1.35.0
# 553cfb2c2205db5f15f3ee8395bbd5cf066d357d
# arm64

