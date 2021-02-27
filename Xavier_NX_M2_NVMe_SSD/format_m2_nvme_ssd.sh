#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR


ls -l /dev/nvme*
# /dev/nvme0

# Caution !! Format SSD !!!
echo "Caution !! Format SSD !!!"
read -p "${X} : Format SSD OK ? (y/N):" yn
case "$yn" in [yY]*) ;; *) echo "abort" ; exit ;; esac

read -p "${X} : Format SSD OK ? (y/N):" yn
case "$yn" in [yY]*) ;; *) echo "abort" ; exit ;; esac

read -p "${X} : LAST CHANCE !! OK ? (y/N):" yn
case "$yn" in [yY]*) ;; *) echo "abort" ; exit ;; esac


# Format SSD Device to GPT Linux filesystem
sudo sfdisk --delete /dev/nvme0n1
echo ',,,;' | sudo sfdisk -X gpt /dev/nvme0n1

# Check Formatted Device
sudo sfdisk -l /dev/nvme0n1
# Device         Start        End    Sectors  Size Type
# /dev/nvme0n1p1  2048 1000215182 1000213135  477G Linux filesystem

lsblk -ifp | grep nvme
# /dev/nvme0n1
# `-/dev/nvme0n1p1


# Format Partition to ext4
sudo mke2fs -F -t ext4 /dev/nvme0n1p1

# Check Format Partition
lsblk -ifp | grep nvme
# /dev/nvme0n1
# `-/dev/nvme0n1p1  ext4              xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx


# ===
# ===
cd $SCRIPT_DIR
if [ -e ../bell.sh ]; then
  chmod +x ../bell.sh
  bash ../bell.sh
fi

