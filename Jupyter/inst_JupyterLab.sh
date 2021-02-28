#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# pip3
which pip3
if [ $? -eq 0 ]; then
  sudo apt install python3-pip
fi

pip3 -V
# pip 9.0.1 from /usr/lib/python3/dist-packages (python 3.6)


# ===
# ===
# Jupyter version
which jupyter-lab
if [ $? -eq 0 ]; then
  jupyter --version
  echo "Already Exists JupyterLab"
  exit 0
fi


# ====
# Jupyter Notebook
# https://jupyter.org/
sudo apt-get install -y libbz2-dev libsqlite3-dev libffi-dev


# ====
# notebook 6.2.0 Released: Jan 14, 2021
# https://pypi.org/project/notebook/
# Jupyter Notebook
# sudo -H pip3 install notebook


# ====
# JupyterLab
sudo -H pip3 install jupyterlab
# jupyterlab-3.0.9-py3
# jupyter-lab


jupyter --version
# jupyter core     : 4.7.1
# jupyter-notebook : 6.2.0
# qtconsole        : not installed
# ipython          : 7.16.1
# ipykernel        : 5.5.0
# jupyter client   : 6.1.11
# jupyter lab      : 3.0.9
# nbconvert        : 6.0.7
# ipywidgets       : not installed
# nbformat         : 5.1.2
# traitlets        : 4.3.3


# ====
# sudo apt remove --purge nodejs npm
# curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# sudo apt-get update && sudo apt-get install -y yarn
# sudo apt-get install -y nodejs
# node -v
# v12.20.1
# npm -v
# 6.14.10


# ====
# Enable Jupyter Widgets UI Library ipywidgets
# ipywidgets: Interactive HTML Widgets
# https://github.com/jupyter-widgets/ipywidgets
# ImportError: IProgress not found. Please update jupyter and ipywidgets.
#  See https://ipywidgets.readthedocs.io/en/stable/user_install.html
sudo pip3 install ipywidgets
# Successfully installed ipywidgets-7.6.3 jupyterlab-widgets-1.0.0 widgetsnbextension-3.5.1


# can be skipped for notebook version 5.3 and above
# sudo jupyter nbextension enable --py --sys-prefix widgetsnbextension
# jupyter nbextension enable --py widgetsnbextension
jupyter nbextension enable --py widgetsnbextension
# Enabling notebook extension jupyter-js-widgets/extension... - Validating: OK

# Install the front-end extension to JupyterLab
# ValueError: Please install Node.js and npm before continuing installation.
#  You may be able to install Node.js from your package manager, from conda,
#   or directly from the Node.js website (https://nodejs.org).
# sudo jupyter labextension install @jupyter-widgets/jupyterlab-manager


echo "jupyter-lab --ip=* --no-browser"
echo "jupyter-lab --ip=* --no-browser --NotebookApp.token=''"
echo "jupyter-lab --ip=* --no-browser --NotebookApp.token='hogehoge'"


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

