#!/bin/bash

# L4T-README
# README-vnc.txt

grep "^AutomaticLoginEnable" /etc/gdm3/custom.conf
if [ $? -eq 0 ]; then
  echo "Already Activated Vino VNC"
  exit 0
fi


cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


# ----------------------------------------------------------------------
echo "Installing the VNC Server"
# ----------------------------------------------------------------------
# It is expected that the VNC server software is pre-installed.
#  Execute the following commands to ensure that it is:
sudo apt update
sudo apt install vino
sudo apt install nano

# ----------------------------------------------------------------------
echo "Enabling the VNC Server"
# ----------------------------------------------------------------------
# Execute the following commands to enable the VNC server:

# Enable the VNC server to start each time you log in
sudo ln -s ../vino-server.service \
    /usr/lib/systemd/user/graphical-session.target.wants

# Configure the VNC server
gsettings set org.gnome.Vino prompt-enabled false
gsettings set org.gnome.Vino require-encryption false

# Set a password to access the VNC server
# Replace thepassword with your desired password
gsettings set org.gnome.Vino authentication-methods "['vnc']"
# gsettings set org.gnome.Vino vnc-password $(echo -n 'thepassword'|base64)
# gsettings set org.gnome.Vino vnc-password $(echo -n 'max8char'|base64)
gsettings set org.gnome.Vino vnc-password $(echo -n 'password'|base64)

# ----------------------------------------------------------------------
echo "Setting the Desktop Resolution"
# ----------------------------------------------------------------------
# sudo nano /etc/X11/xorg.conf

cat - << EOS > xorg_tmp.conf

Section "Screen"
   Identifier    "Default Screen"
   Monitor       "Configured Monitor"
   Device        "Tegra0"
   SubSection "Display"
       Depth    24
       Virtual 1280 800 # Modify the resolution by editing these values
   EndSubSection
EndSection
EOS

cat /etc/X11/xorg.conf xorg_tmp.conf > xorg.conf
rm xorg_tmp.conf
sudo cp xorg.conf /etc/X11/xorg.conf
rm xorg.conf
cat /etc/X11/xorg.conf


# ===
echo "Enable Automatic Login"
# The VNC server is only available after you have logged in to Jetson locally.
# If you wish VNC to be available automatically,
#  use the system settings application to enable automatic login.

# GDM GNOME Display Manager
# sudo nano /etc/gdm3/custom.conf
# /etc/gdm3/custom.conf
#  AutomaticLoginEnable = true
#  AutomaticLogin = user1
cp /etc/gdm3/custom.conf .
sed -i 's/^#  AutomaticLoginEnable/AutomaticLoginEnable/' custom.conf
sed -i "s/^AutomaticLoginEnable=False/AutomaticLoginEnable = true/" custom.conf
sed -i "s/^#  AutomaticLogin = .*/AutomaticLogin = $(whoami)/" custom.conf
sudo cp custom.conf /etc/gdm3/custom.conf
rm custom.conf
cat /etc/gdm3/custom.conf

# LightDM
# sudo nano /etc/lightdm/lightdm.conf
# /etc/lightdm/lightdm.conf
# [SeatDefaults]
# autologin-user=jetson
# cp /etc/lightdm/lightdm.conf .
# sed -i "s/^autologin-user=.*/autologin-user=$(whoami)/" lightdm.conf
# sudo cp lightdm.conf /etc/lightdm/lightdm.conf
# rm lightdm.conf
# cat /etc/lightdm/lightdm.conf


# Reboot the system so that the settings take effect
# ===
# sudo reboot
echo '---'
echo "Reboot the system so that the settings take effect"
echo ''
echo "sudo reboot"


# UUID
# nmcli connection show
# NAME                UUID                                  TYPE      DEVICE
# Wired connection 1  11111111-2222-3333-4444-555555555555  ethernet  eth0
# l4tbr0              88888888-8888-8888-8888-888888888888  bridge    l4tbr0

# dconf write /org/gnome/settings-daemon/plugins/sharing/vino-server/enabled-connections "['11111111-2222-3333-4444-555555555555']"

# dconf read /org/gnome/settings-daemon/plugins/sharing/vino-server/enabled-connections
# ss -lnt | grep 5900

# export DISPLAY=:0
# /usr/lib/vino/vino-server

# export DISPLAY=:1
# /usr/lib/vino/vino-server

# gsettings list-recursively org.gnome.Vino


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

