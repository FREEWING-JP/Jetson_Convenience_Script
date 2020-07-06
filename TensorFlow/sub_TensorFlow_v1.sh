#!/bin/bash

cd `dirname $0`

# ===
# ===

chmod +x dependencies.sh
bash ./dependencies.sh

TF_URL=$1

# Installing TensorFlow 1.x
# TF-1.15
sudo pip3 install --pre --no-cache-dir --extra-index-url $TF_URL 'tensorflow<2'

# Verifying The Installation
python3 -c "import tensorflow; print (tensorflow.__version__)"
# 1.15.2

