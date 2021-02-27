#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


ls -l /dev/nvme*
# /dev/nvme0


# Check Partition
lsblk -ifp | grep nvme


# sudo parted -s /dev/nvme0n1 mklabel gpt
# ls -l /dev/nvme0n1*
# # /dev/nvme0n1

# sudo parted -s /dev/nvme0n1 mkpart "NVMe_SSD_512GB" ext4 0% 100%
# # /dev/nvme0n1
# # /dev/nvme0n1p1

# sudo parted -l | grep NVMe
# #  1      1049kB  512GB  512GB  ext4         NVMe_SSD_512GB

sudo mkdir /jetson_ssd
sudo mount /dev/nvme0n1p1 /jetson_ssd
sudo chmod 755 /jetson_ssd

df -h


# Add UUID to fstab
# UUID=5f04643c-1234-4145-abcd-123456789012 /jetson_ssd  ext4  defaults  0  2
UUID=`sudo tune2fs -l /dev/nvme0n1p1 | grep UUID | awk '{print $3}'`
echo $UUID

cat /etc/fstab
cp /etc/fstab tmp_fstab
echo UUID=$UUID /jetson_ssd  ext4  defaults  0  2 >> tmp_fstab
cat tmp_fstab
sudo cp tmp_fstab /etc/fstab


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
