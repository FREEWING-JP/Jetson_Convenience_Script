#!/bin/bash

# ===
# Color Command Prompt
# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w \$\[\033[00m\] '
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w \$\[\033[00m\] '

if [ -f /sys/devices/soc0/soc_id ]; then
  tegra_cip_id=$(cat /sys/devices/soc0/soc_id)
else
  tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
fi
echo $tegra_cip_id

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  PS1="\[\033[41m\]X\[\033[00m\] ${PS1}"
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  PS1="\[\033[44m\]N\[\033[00m\] ${PS1}"
fi

echo '# Color Command Prompt' >> ~/.bashrc
echo "PS1='$PS1'" >> ~/.bashrc

# ===
# bash command line history settings
# echo export HISTCONTROL=ignoreboth >> ~/.bashrc
echo export HISTCONTROL=ignorespace:ignoredups:erasedups >> ~/.bashrc

source ~/.bashrc

