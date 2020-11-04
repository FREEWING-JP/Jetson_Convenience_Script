#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# ===
if [ -d ~/stylegan2 ]; then
  echo "Already Exists Directory"
  exit 0
fi


# ===
# pip3
which pip3
if [ $? -eq 0 ]; then
  sudo apt install python3-pip
fi

pip3 -V
# pip 20.2.4 from /usr/local/lib/python3.6/dist-packages/pip (python 3.6)


# ===
# tensorflow
pip3 freeze | grep tensorflow
if [ $? -ne 0 ]; then
  echo "no tensorflow"
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


# python3 PIL Pillow
# ModuleNotFoundError: No module named 'PIL'
# Pillow==8.0.1
pip3 freeze | grep Pillow
if [ $? -ne 0 ]; then
  sudo pip3 install pillow
fi


# ===
# ===
# StyleGAN2
cd
git clone https://github.com/NVlabs/stylegan2 --depth 1
cd stylegan2


nvcc test_nvcc.cu -o test_nvcc -run
# CPU says hello.
# GPU says hello.


# undefined symbol _ZN10tensorflow12OpDefBuilder5InputESs
sed -i -e "s/-D_GLIBCXX_USE_CXX11_ABI=0/-D_GLIBCXX_USE_CXX11_ABI=1/g" dnnlib/tflib/custom_ops.py

cat dnnlib/tflib/custom_ops.py | grep ABI
# compile_opts += ' --compiler-options \'-fPIC -D_GLIBCXX_USE_CXX11_ABI=1\''

# Generate uncurated ffhq images (matches paper Figure 12)
python3 run_generator.py generate-images --network=gdrive:networks/stylegan2-ffhq-config-f.pkl \
  --seeds=6600-6625 --truncation-psi=0.5
# dnnlib: Finished run_generator.generate_images() in 5m 46s.
# Jetson Nano 5m 46s
# Xavier NX 3m 06s


# Generate curated ffhq images (matches paper Figure 11)
python3 run_generator.py generate-images --network=gdrive:networks/stylegan2-ffhq-config-f.pkl \
  --seeds=66,230,389,1518 --truncation-psi=1.0
# dnnlib: Finished run_generator.generate_images() in 6m 08s.
# Jetson Nano 6m 08s
# Xavier NX 1m 52s


# Generate uncurated car images
python3 run_generator.py generate-images --network=gdrive:networks/stylegan2-car-config-f.pkl \
  --seeds=6000-6025 --truncation-psi=0.5
# dnnlib: Finished run_generator.generate_images() in 4m 15s.
# Jetson Nano 4m 15s
# Xavier NX 2m 9s


# Example of style mixing (matches the corresponding video clip)
python3 run_generator.py style-mixing-example --network=gdrive:networks/stylegan2-ffhq-config-f.pkl \
  --row-seeds=85,100 --col-seeds=821 --truncation-psi=1.0

ls -l results
ls -l results/*
# */


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

