#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


ls -l /dev/nvme*
# /dev/nvme0

read -p "${X} : Make M.2 NVMe SSD to Boot Device OK ? (y/N):" yn
case "$yn" in [yY]*) ;; *) echo "abort" ; exit ;; esac

read -p "${X} : LAST CHANCE !! OK ? (y/N):" yn
case "$yn" in [yY]*) ;; *) echo "abort" ; exit ;; esac


### Jetson Xavier NX Booting from M.2 NVMe SSD
echo "Jetson Xavier NX - Run from SSD"
echo "https://www.jetsonhacks.com/2020/05/29/jetson-xavier-nx-run-from-ssd/"

# Clone the repository
cd
git clone https://github.com/jetsonhacks/rootOnNVMe.git
cd rootOnNVMe/

# copy the rootfs of the eMMC/SD card to the SSD
./copy-rootfs-ssd.sh
# Error when Wrong M.2SSD Format type (not GPT)
# *** Skipping any contents from this failed directory ***
# rsync: recv_generator: mkdir "/mnt/opt" failed: No space left on device (28)

#  15,543,736,526  96%   53.11MB/s    0:04:39 (xfr#148591, to-chk=0/211367)

# Check Mount Device
mount | grep mmcblk
# /dev/mmcblk0p1 on / type ext4 (rw,relatime,data=ordered)

mount | grep nvme
# /dev/nvme0n1p1 on /mnt type ext4 (rw,relatime,data=ordered)

# add a service
sudo ./setup-service.sh


# ===
echo '---'
echo "type 'sudo reboot'"
echo ''
echo "sudo reboot"


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

