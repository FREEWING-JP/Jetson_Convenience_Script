#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


VSCODE_VER=1.52.1
MEMORY_SIZE=6404

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
cat package.json | grep max_old_space_size

# --max_old_space_size=5120 NG minify-vscode
#  - FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
# free -h
#               total        used        free      shared  buff/cache   available
# Mem:           7.6G        292M        6.5G         16M        857M        7.1G
# Swap:          3.8G         29M        3.8G

# --max_old_space_size=6404 OK
sed -i "s/8192/$MEMORY_SIZE/g" package.json
cat package.json | grep max_old_space_size



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
# ea3859d4ba2f3e577a159bc91e3074c5d85c0523
# arm64

