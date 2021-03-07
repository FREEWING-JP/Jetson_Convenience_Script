#!/bin/bash

# ===
# ===
# Python version 3.6 Requires Python >=3.6

# Install system packages required by TensorFlow
sudo apt-get update
sudo apt-get -y install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran

# Install and upgrade pip3
sudo apt-get -y install python3-pip
sudo pip3 install -U pip testresources setuptools==54.1.1

# Install Cython
#  raise OSError('Cython needs to be installed in Python as a module')
# sudo pip3 install --no-use-wheel --no-cache-dir Cython
# DEPRECATION: --no-use-wheel is deprecated and will be removed in the future.  Please use --no-binary :all: instead.
# https://kurozumi.github.io/pip/reference/pip_wheel.html
# sudo pip3 install --no-binary :all: --no-cache-dir Cython
# Successfully installed Cython-0.29.22
sudo pip3 install -U Cython==0.29.22
sudo pip3 install -U numpy==1.19.5

# Install the Python package dependencies
# sudo pip3 install -U numpy==1.16.1 future==0.17.1 mock==3.0.5 h5py==2.9.0 keras_preprocessing==1.0.5 keras_applications==1.0.8 gast==0.2.2 futures protobuf pybind11
# ERROR: tensorflow 2.1.0+nv20.4 has requirement keras-preprocessing>=1.1.0, but you'll have keras-preprocessing 1.0.5 which is incompatible.

# Install the Python package dependencies
# keras_preprocessing==1.1.0
sudo pip3 install -U future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.2 keras_applications==1.0.8 gast==0.4.0 futures protobuf pybind11

