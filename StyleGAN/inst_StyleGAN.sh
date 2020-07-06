#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/stylegan ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# TensorFlow version
TF_VERSION=`python3 -c "import tensorflow; print (tensorflow.VERSION)"`
if [ $? = 0 ]; then
  echo $TF_VERSION
else
  echo "no tensorflow"
  exit 0
fi

if [[ ${TF_VERSION} =~ ^([0-9]+)\..*$ ]]; then
  echo ${BASH_REMATCH[1]}
  if [ ! "${BASH_REMATCH[1]}" = "1" ]; then
    echo "No Support except TensorFlow v1.x"
    exit 0
  fi
fi


# ===
# ===
# StyleGAN
cd
git clone https://github.com/NVlabs/stylegan --depth 1
cd stylegan

# ModuleNotFoundError: No module named 'PIL'
sudo pip3 install pillow

# Using pre-trained networks
python3 pretrained_example.py

# example.png
ls -l results/

cp $SCRIPT_DIR/pretrained_example_mod.py .
python3 pretrained_example_mod.py https://drive.google.com/uc?id=1MEGjdvVpUsu1jB4zrXZN7Y4kBBOzizDQ 10 10 face_
ls -l results/


# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  # (0) Resource exhausted: OOM when allocating tensor
  # Hint: If you want to see a list of allocated tensors when OOM happens
  # add report_tensor_allocations_upon_oom to RunOptions for current allocation info.
  grep "w=1024, h=1024" generate_figures.py
  # sed -i 's/w=1024, h=1024/w=256, h=256/' generate_figures.py
  sed -i '/figure02/s/^/# /g' generate_figures.py
  sed -i '/figure03/s/^/# /g' generate_figures.py
  sed -i '/figure04/s/^/# /g' generate_figures.py
  sed -i '/figure05/s/^/# /g' generate_figures.py
  sed -i '/figure08/s/^/# /g' generate_figures.py
fi

python3 generate_figures.py

# *.png
ls -l results/


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

