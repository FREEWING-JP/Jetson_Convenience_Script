#!/bin/bash

# ===
# ===

# Install cURL nano git
sudo apt update
sudo apt install -y curl nano git

# Install Node.js v10
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

sudo apt-get install gcc g++ make

# Install Yarn
curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

nodejs -v
# v10.20.1

yarn -v
# 1.22.4

npm -v
# 6.14.4

# Install Package Library
sudo apt install -y libx11-dev libxkbfile-dev
sudo apt install -y libsecret-1-dev
sudo apt install -y fakeroot rpm

# Install Package Library one liner
sudo apt install -y libx11-dev libxkbfile-dev libsecret-1-dev fakeroot rpm

