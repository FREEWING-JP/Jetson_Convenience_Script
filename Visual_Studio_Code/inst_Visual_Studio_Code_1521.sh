#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


echo https://code.visualstudio.com/#alt-downloads
echo https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64
exit 0

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
# [09:05:31] Starting minify-vscode ...

<--- Last few GCs --->

[12081:0x21fe7970]  1311109 ms: Scavenge 4504.2 (4769.4) -> 4503.4 (4769.9) MB, 19.7 / 0.0 ms  (average mu = 0.371, current mu = 0.367) allocation failure
[12081:0x21fe7970]  1311148 ms: Scavenge 4509.3 (4774.9) -> 4508.4 (4775.4) MB, 22.3 / 0.0 ms  (average mu = 0.371, current mu = 0.367) allocation failure
[12081:0x21fe7970]  1311262 ms: Scavenge 4519.3 (4785.3) -> 4518.4 (4785.8) MB, 60.3 / 0.0 ms  (average mu = 0.371, current mu = 0.367) allocation failure


<--- JS stacktrace --->

==== JS stack trace =========================================

    0: ExitFrame [pc: 0x2ee638cc]
    1: StubFrame [pc: 0x2ee12eb8]
Security context: 0x00002cc9e6c1 <JSObject>
    2: /* anonymous */(aka /* anonymous */) [0x7e36cb7899] [/home/jetson/vscode/build/node_modules/terser/dist/bundle.min.js:~1] [pc=0x34b57054](this=0x000022e826f1 <undefined>)
    3: /* anonymous */ [0x7e36cb70b9] [/home/jetson/vscode/build/node_modules/terser/dist/bundle.min.js:~1] [pc=0x34b63904](this=0x007e376a2ae1 <Object ...

FATAL ERROR: Ineffective mark-compacts near heap limit Allocation failed - JavaScript heap out of memory
 1: 0x8fe0b8 node::Abort() [gulp vscode-linux-arm64-min --no-respawning]
 2: 0x8fe0f8  [gulp vscode-linux-arm64-min --no-respawning]
 3: 0xae912c v8::Utils::ReportOOMFailure(v8::internal::Isolate*, char const*, bool) [gulp vscode-linux-arm64-min --no-respawning]


yarn run gulp vscode-linux-arm64-build-deb

# Install from DEB package
sudo dpkg -i ./.build/linux/deb/arm64/deb/code-oss_$VSCODE_VER-*_arm64.deb

code-oss -v
# 1.52.1
# 
# arm64

