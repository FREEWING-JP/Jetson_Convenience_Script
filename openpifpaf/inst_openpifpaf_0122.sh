#!/bin/sh

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


export OPENBLAS_CORETYPE=ARMV8

# ===
# ===
# Pytorch version
TF_VERSION=`python3 -c "import torch; print (torch.__version__)"`
if [ $? -ne 0 ]; then
  echo "no Pytorch"
  exit 0
fi

TF_VERSION=`python3 -c "import torchvision; print (torchvision.__version__)"`
if [ $? -ne 0 ]; then
  echo "no torchvision"
  exit 0
fi


#     raise Exception('please install matplotlib')
# Exception: please install matplotlib
sudo pip3 install matplotlib==3.3.4


# pip3 install openpifpaf==0.12.2
#   Could not find a version that satisfies the requirement torch>=1.7.1 (from openpifpaf==0.12.2) (from versions: 0.1.2, 0.1.2.post1, 0.1.2.post2)
# No matching distribution found for torch>=1.7.1 (from openpifpaf==0.12.2)

# https://pypi.org/project/openpifpaf/0.12.2/
# Ignore package dependencies --no-deps, --no-dependencies
sudo pip3 install openpifpaf==0.12.2 --no-deps
# Successfully installed openpifpaf-0.12.2

cd
git clone https://github.com/vita-epfl/openpifpaf --depth 1
cp openpifpaf/docs/coco/*.jpg .
# */
python3 -m openpifpaf.predict 000000081988.jpg --image-min-dpi=200 --show-file-extension=jpg --image-output

ls -l *.jpg

