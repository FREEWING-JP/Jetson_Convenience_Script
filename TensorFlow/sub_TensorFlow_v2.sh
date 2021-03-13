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
echo "# ==="
echo "# Installing TensorFlow version 2"
sudo pip3 install --pre --no-cache-dir --extra-index-url $TF_URL tensorflow

# Successfully installed astunparse-1.6.3 cachetools-4.2.1 flatbuffers-1.12 gast-0.3.3 google-auth-1.27.1 google-auth-oauthlib-0.4.3 grpcio-1.32.0 numpy-1.19.5 oauthlib-3.1.0 pyasn1-0.4.8 pyasn1-modules-0.2.8 requests-2.25.1 requests-oauthlib-1.3.0 rsa-4.7.2 tensorboard-2.4.1 tensorboard-plugin-wit-1.8.0 tensorflow-2.4.0+nv21.2 tensorflow-estimator-2.4.0

# Verifying The Installation
pip3 list | grep numpy | grep 1.19.5
if [ $? = 0 ]; then
  export OPENBLAS_CORETYPE=ARMV8
fi

python3 -c "import tensorflow; print (tensorflow.version.VERSION)"
# 2.4.0

cat << EOS
# Illegal instruction(core dumped) error on Jetson Nano / Jetson Xavier NX
# https://stackoverflow.com/questions/65631801/illegal-instructioncore-dumped-error-on-jetson-nano
# Illegal instruction (core dumped)
# export OPENBLAS_CORETYPE=ARMV8
# python3 -c "import tensorflow; print (tensorflow.version.VERSION)"
# 2.4.0
EOS

