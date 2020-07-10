#!/bin/bash

# disable auto update and auto upgrade
# stop apt-daily and apt-daily-upgrades
sudo systemctl mask apt-daily.service
sudo systemctl mask apt-daily.timer
sudo systemctl mask apt-daily-upgrade.service
sudo systemctl mask apt-daily-upgrade.timer

# uninstall auto update
# uninstall unattended-upgrades
sudo apt-get -y remove unattended-upgrades

