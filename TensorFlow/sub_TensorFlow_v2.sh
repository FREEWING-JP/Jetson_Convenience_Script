#!/bin/bash

cd `dirname $0`

# ===
# ===

chmod +x dependencies.sh
bash ./dependencies.sh

TF_URL=$1

# Installing TensorFlow version 2
# TF-2.1.0
# Install TensorFlow using the pip3 command. This command will install the latest version of TensorFlow compatible with JetPack 4.3
sudo pip3 install --pre --no-cache-dir --extra-index-url $TF_URL tensorflow

# Verifying The Installation
python3 -c "import tensorflow; print (tensorflow.version.VERSION)"
# 2.1.0

