#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ===
# dummy sudo
sudo echo .

# ===
uname -a

lsb_release -a

# ===
chmod +x bash_init.sh
bash ./bash_init.sh

# NVIDIA Jetson Nano FULL power mode
chmod +x create_jetson_clocks.sh
bash ./create_jetson_clocks.sh

# ===
chmod +x add_cuda_environment.sh
bash ./add_cuda_environment.sh

# ===
chmod +x add_blas_environment.sh
bash ./add_blas_environment.sh

# ===
chmod +x stop_apt_daily.sh
bash ./stop_apt_daily.sh

# Install cURL nano git htop Mercurial tree
sudo apt update
sudo apt install -y curl nano git htop mercurial tree

# ===
echo '---'
echo "type 'source ~/.bashrc'"
echo ''
echo "source ~/.bashrc"
echo 'or'
echo "sudo reboot"

# sudo visudo
echo '---'
echo "sudo visudo"
echo ''
echo "Defaults        env_reset, timestamp_timeout=-1"
echo 'or'
echo "echo 'Defaults        env_reset, timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo"
echo ''


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

