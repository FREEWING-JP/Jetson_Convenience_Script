#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

DEEPSTREAM_VER=5.0
echo $DEEPSTREAM_VER

DEEPSTREAM_DIR=/opt/nvidia/deepstream/deepstream-$DEEPSTREAM_VER
echo $DEEPSTREAM_DIR


# ===
ls -l /opt/nvidia/deepstream
if [ $? -eq 0 ]; then
  echo "Already Exists NVIDIA DeepStream SDK"
  exit 0
fi


# ===
# ===
# NVIDIA DeepStream SDK
# https://docs.nvidia.com/metropolis/deepstream/dev-guide/text/DS_Quickstart.html#jetson-setup

# Install Dependencies
sudo apt install -y \
 libssl1.0.0 \
 libgstreamer1.0-0 \
 gstreamer1.0-tools \
 gstreamer1.0-plugins-good \
 gstreamer1.0-plugins-bad \
 gstreamer1.0-plugins-ugly \
 gstreamer1.0-libav \
 libgstrtspserver-1.0-0 \
 libjansson4=2.11-1


# Install librdkafka (to enable Kafka protocol adaptor for message broker)
# Clone the librdkafka repository from GitHub:
cd
git clone https://github.com/edenhill/librdkafka.git
# Configure and build the library:
cd librdkafka
git reset --hard 7101c2310341ab3f4675fc565f64f0967e135a6a
./configure
make -j$(nproc)
sudo make install

# Copy the generated libraries to the deepstream directory:
sudo mkdir -p $DEEPSTREAM_DIR/lib
sudo cp /usr/local/lib/librdkafka* $DEEPSTREAM_DIR/lib


# Install NVIDIA V4L2 GStreamer plugin
cat /etc/apt/sources.list.d/nvidia-l4t-apt-source.list

# sudo nano /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
# deb https://repo.download.nvidia.com/jetson/common r32.5 main
# deb https://repo.download.nvidia.com/jetson/<platform> r32.5 main
# <platform>
#  t186 for Jetson TX2 series
#  t194 for Jetson AGX Xavier series or Jetson Xavier NX
#  t210 for Jetson Nano or Jetson TX1

# sudo apt update
sudo apt install -y --reinstall nvidia-l4t-gstreamer


# Method 3: Using the DeepStream Debian package
# Install the DeepStream SDK
# sudo apt-get install ./deepstream-5.0_5.0.1-1_arm64.deb

# Method 4: Using the apt-server
# sudo nano /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
# deb https://repo.download.nvidia.com/jetson/common r32.5 main

# sudo apt update
sudo apt install -y deepstream-$DEEPSTREAM_VER
# deepstream-5.0 (5.0.1-1)
# NOTE: sources and samples folders will be found in /opt/nvidia/deepstream/deepstream-5.0

DEEPSTREAM_DIR=/opt/nvidia/deepstream/deepstream
echo "DEEPSTREAM_DIR=$DEEPSTREAM_DIR"

echo '# NVIDIA DeepStream SDK' >> ~/.bashrc
echo "export DEEPSTREAM_DIR=$DEEPSTREAM_DIR" >> ~/.bashrc

ls -l $DEEPSTREAM_DIR/sources/apps/sample_apps

# ===
echo '---'
echo "type 'source ~/.bashrc'"
echo ''
echo "source ~/.bashrc"

