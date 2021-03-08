#!/bin/bash

cd `dirname $0`

# ===
# ===

chmod +x dependencies.sh
bash ./dependencies.sh v1

TF_URL=$1

# Installing TensorFlow 1.x
# TF-1.15
echo "# ==="
echo "# Installing TensorFlow 1.x"
sudo pip3 install --pre --no-cache-dir --extra-index-url $TF_URL 'tensorflow<2'

# Successfully installed absl-py-0.11.0 astor-0.8.1 dataclasses-0.8 google-pasta-0.2.0 grpcio-1.36.1 importlib-metadata-3.7.2 markdown-3.3.4 opt-einsum-3.3.0 tensorboard-1.15.0 tensorflow-1.15.5+nv21.2 tensorflow-estimator-1.15.1 termcolor-1.1.0 typing-extensions-3.7.4.3 werkzeug-2.0.0rc2 wrapt-1.12.1 zipp-3.4.1

# Verifying The Installation
python3 -c "import tensorflow; print (tensorflow.__version__)"
# 1.15.5

