#!/bin/sh

cd `dirname $0`

# ===
# Jetson Best Fastest mode bash script
bash -c "echo \#\!/bin/sh> tmp.sh"
bash -c "echo >> tmp.sh"
bash -c "echo sleep 2 >> tmp.sh"

if [ -f /sys/devices/soc0/soc_id ]; then
  tegra_cip_id=$(cat /sys/devices/soc0/soc_id)
else
  tegra_cip_id=$(cat /sys/module/tegra_fuse/parameters/tegra_chip_id)
fi
echo $tegra_cip_id

mode=0

# Jetson Xavier NX
if [ $tegra_cip_id = "25" ]; then
  mode=2
fi

# Jetson Nano
if [ $tegra_cip_id = "33" ]; then
  mode=0
fi

bash -c "echo sudo nvpmodel -m $mode >> tmp.sh"
bash -c "echo sudo nvpmodel -q >> tmp.sh"

bash -c "echo sleep 1 >> tmp.sh"
bash -c "echo sudo jetson_clocks >> tmp.sh"

bash -c "echo sudo jetson_clocks --fan >> tmp.sh"
bash -c "echo sudo jetson_clocks --show >> tmp.sh"

chmod +x tmp.sh

mv tmp.sh ~/.jetson_clocks_max.sh
sudo ~/.jetson_clocks_max.sh

# jetson@jetson-desktop:~ $ whoami
# jetson

IAM=`whoami`
echo $IAM
CRONCMD=`echo "@reboot /home/$IAM/.jetson_clocks_max.sh > /dev/null 2>&1"`
echo $CRONCMD
(sudo crontab -l; echo "$CRONCMD") | sudo crontab -
sudo crontab -l
# @reboot /home/jetson/.jetson_clocks_max.sh > /dev/null 2>&1

