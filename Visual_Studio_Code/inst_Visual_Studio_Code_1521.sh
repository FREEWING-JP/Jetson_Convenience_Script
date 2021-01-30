#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


VSCODE_VER=1.52.1

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


# Git clone vscode 1.52.1 17299e4
# Xavier NX Can build 1.52.1 version of Visual Studio Code
cd
git clone https://github.com/Microsoft/vscode.git -b $VSCODE_VER --depth 1

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
sudo dpkg -i ./.build/linux/deb/arm64/deb/code-oss_$VSCODE_VER-*_arm64.deb

code-oss -v
# 1.52.1
# 
# arm64

