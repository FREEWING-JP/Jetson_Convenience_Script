#!/bin/bash

TF_VER=$1

# ===
# ===
# Python version 3.6 Requires Python >=3.6

# Install system packages required by TensorFlow
echo "# ==="
echo "# Install system packages required by TensorFlow"
sudo apt-get update
sudo apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran

# Install and upgrade pip3
sudo apt-get -y install python3-pip
sudo pip3 install -U pip testresources setuptools==54.1.1


sudo pip3 install -U wheel==0.36.2
# Successfully installed wheel-0.36.2


# Install Cython
echo "# ==="
echo "# Install Cython"
#  raise OSError('Cython needs to be installed in Python as a module')
# sudo pip3 install --no-use-wheel --no-cache-dir Cython
# DEPRECATION: --no-use-wheel is deprecated and will be removed in the future.  Please use --no-binary :all: instead.
# https://kurozumi.github.io/pip/reference/pip_wheel.html
# sudo pip3 install --no-binary :all: --no-cache-dir Cython
# Successfully installed Cython-0.29.22
sudo pip3 install -U Cython==0.29.22

# Install numpy
echo "# ==="
echo "# Install numpy"

# numpy/core/src/multiarray/numpyos.c:18:10: fatal error: xlocale.h: No such file or directory
#        #include <xlocale.h>
# ubuntu 18.04 : 'xlocale.h' file not found #503
# https://github.com/carla-simulator/carla/issues/503
sudo ln -s /usr/include/locale.h /usr/include/xlocale.h

sudo pip3 install -U six==1.15.0
# Successfully installed six-1.15.0

# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
# uff 0.6.9 requires protobuf>=3.3.0, but you have protobuf 3.0.0 which is incompatible.
sudo pip3 install -U protobuf==3.15.5

sudo pip3 install -U uff==0.6.9

NUMPY_VER=1.19.5
GAST_VER=0.3.3
if [ $TF_VER = "v1" ]; then
  NUMPY_VER=1.18.5
  GAST_VER=0.2.2
fi
echo sudo pip3 install -U numpy==$NUMPY_VER
sudo pip3 install -U numpy==$NUMPY_VER


# Install the Python package dependencies
echo "# ==="
echo "# Install the Python package dependencies"
# sudo pip3 install -U numpy==1.16.1 future==0.17.1 mock==3.0.5 h5py==2.9.0 keras_preprocessing==1.0.5 keras_applications==1.0.8 gast==0.2.2 futures protobuf pybind11
# ERROR: tensorflow 2.1.0+nv20.4 has requirement keras-preprocessing>=1.1.0, but you'll have keras-preprocessing 1.0.5 which is incompatible.

# Install the Python package dependencies
# keras_preprocessing==1.1.0
sudo pip3 install -U future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==$GAST_VER futures==3.1.1 pybind11==2.6.2

python3 -c "import numpy as np; print(np.__version__); print(np.__path__); print(np.get_include()); np.show_config();"

