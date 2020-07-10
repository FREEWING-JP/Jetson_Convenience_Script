#!/bin/bash

# ===
sudo swapoff -a
swapon

# ===
# disable ZRAM
# /etc/systemd/nvzramconfig.sh
sudo systemctl disable nvzramconfig

# enable ZRAM
# sudo systemctl enable nvzramconfig


# Create 6GB(6 * 1024 * 1024 * 1024 = 6442450944)
# sudo dd if=/dev/zero of=/var/tmp/swap.img bs=1M count=6144
# 8GB is "-l 8g"
sudo fallocate -l 6g /var/tmp/swap.img

ls -l /var/tmp/swap.img
# -rw-r--r-- 1 root root 6442450944  6月 25 19:14 /var/tmp/swap.img

# 
sudo mkswap /var/tmp/swap.img

# chmod
sudo chmod 0600 /var/tmp/swap.img

# 
sudo swapon -p 1 /var/tmp/swap.img

# 
swapon
# NAME              TYPE SIZE USED PRIO
# /var/tmp/swap.img file   6G   0B    1

# sudo nano /etc/fstab
sudo sh -c "echo /var/tmp/swap.img none swap defaults 0 0 >>/etc/fstab"

# enable /etc/fstab
sudo swapon -a

cat /etc/fstab

