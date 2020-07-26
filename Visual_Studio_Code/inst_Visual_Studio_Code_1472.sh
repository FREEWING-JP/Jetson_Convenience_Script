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


# Git clone vscode 1.47.2 17299e4
# Xavier NX Can build 1.47.2 version of Visual Studio Code
cd
git clone https://github.com/Microsoft/vscode.git -b 1.47.2 --depth 1

cd vscode

# Jetson patch
# --max_old_space_size=2048
cat package.json | grep 4095
cat package.json | grep 8192

# --max_old_space_size=5120
sed -i 's/8192/5120/g' package.json


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

# Done in 742.60s.

# Make DEB package
yarn run gulp vscode-linux-arm64-min
yarn run gulp vscode-linux-arm64-build-deb

# Install from DEB package
sudo dpkg -i ./.build/linux/deb/arm64/deb/code-oss_1.47.2-*_arm64.deb

code-oss -v
# 1.47.0
# d5e9aa0227e057a60c82568bf31c04730dc15dcd
# arm64

