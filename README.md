# Jetson Convenience Script
  by FREE WING  
  
http://www.neko.ne.jp/~freewing/  

Donation Button  
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T79HPJ5H79PBU)

---
#### JetPack 4.4 production release L4T 32.4.3 Can't build Caffe and OpenPose 1.6.0 with cuDNN 8.0
Caffe doesn't support cuDNN v8.0 .  
So require disable USE_CUDNN .  
https://forums.developer.nvidia.com/t/jetpack-4-4-l4t-r32-4-3-production-release/140870/21  

* OpenPose 1.7.0 support cuDNN 8.0

---
### for Jetson Nano / Jetson Xavier NX Developer Kit
- NVIDIA Jetson Nano Developer Kit (4GB model)  
https://www.nvidia.com/ja-jp/autonomous-machines/embedded-systems/jetson-nano-developer-kit/  
- NVIDIA Jetson Xavier NX Developer Kit  
https://www.nvidia.com/ja-jp/autonomous-machines/embedded-systems/jetson-xavier-nx/  

##### * not tested Jetson Nano 2GB Developer Kit  

### NVIDIA JetPack

| JetPack | L4T Ver. |/etc/nv_tegra_release|Jetson_Convenience_Script Support|
|:---:|:---:|:---:|:---:|
|4.5.1 PR|L4T 32.5.1|R32 (release), REVISION: 5.1| Current OK |
|4.5 PR|L4T 32.5|R32 (release), REVISION: 5.0| Current OK |
|4.4.1 PR|L4T 32.4.4|R32 (release), REVISION: 4.4|[Archived tag:JetPack_4.4.1](https://github.com/FREEWING-JP/Jetson_Convenience_Script/tree/JetPack_4.4.1)|
|4.4 PR|L4T 32.4.3|R32 (release), REVISION: 4.3|[Archived tag:JetPack_4.4.1](https://github.com/FREEWING-JP/Jetson_Convenience_Script/tree/JetPack_4.4.1)|
|4.4 DP|L4T 32.4.2|R32 (release), REVISION: 4.2|[Archived tag:JetPack_4.4.1](https://github.com/FREEWING-JP/Jetson_Convenience_Script/tree/JetPack_4.4.1)|
|4.3 PR|L4T 32.3.1|xxx| [Archived tag:JetPack_4.4.1](https://github.com/FREEWING-JP/Jetson_Convenience_Script/tree/JetPack_4.4.1)|

- 2021/02 JetPack 4.5.1 PR Production Release  
https://developer.nvidia.com/embedded/jetpack  
- 2021/01 JetPack 4.5 PR Production Release  
- 2020/10 JetPack 4.4.1 PR Production Release  
https://developer.nvidia.com/jetpack-sdk-441-archive  
- JetPack 4.4 PR Production Release  
https://developer.nvidia.com/jetpack-sdk-44-archive  
- JetPack 4.4 DP Developer Preview  
https://developer.nvidia.com/jetpack-sdk-44-dp-archive  
- JetPack 4.3 PR Production Release  
https://developer.nvidia.com/jetpack-43-archive  
- JetPack Archive  
https://developer.nvidia.com/embedded/jetpack-archive  
  
---
### Jetson Nano / Jetson Xavier NX HEADLESS MODE Setup
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_xavier_nx_developer_kit_headless_mode_setup/  
```
NVIDIA Jetson Nano、Jetson Xavier NX Developer Kit HEADLESS MODE Setup
You can use a Jetson Xavier NX Developer Kit in headless mode, that is , without attaching a display .
```
```
* Caution *
Need to Disconnect Display Cable or Power off Display .
If JETSON Detects the Display , It will not go into HEADLESS MODE Setup .
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_xavier_nx_developer_kit_oobe_52.jpg" alt="Jetson HEADLESS MODE Setup" title="Jetson HEADLESS MODE Setup" width="320" height="240"> _ <img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_xavier_nx_developer_kit_headless_mode_setup_4.png" alt="Jetson HEADLESS MODE Setup" title="Jetson HEADLESS MODE Setup" width="320" height="240">  
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_xavier_nx_developer_kit_headless_mode_setup_2.png" alt="Jetson HEADLESS MODE Setup" title="Jetson HEADLESS MODE Setup" width="320" height="240"> _ <img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_xavier_nx_developer_kit_headless_mode_setup_3.png" alt="Jetson HEADLESS MODE Setup" title="Jetson HEADLESS MODE Setup" width="320" height="240">  

---
### Jetson WiFi Setup via Terminal Command Line
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_setup_wifi_connection_nmcli/  
```
SSID='WIFI-SSID'
PASSWORD='PLAIN-PASSWORD'

sudo nmcli device wifi connect $SSID password $PASSWORD

sudo nmcli con add type wifi con-name $SSID ifname wlan0 ssid $SSID
sudo nmcli con modify $SSID wifi-sec.key-mgmt wpa-psk
sudo nmcli con modify $SSID wifi-sec.psk $PASSWORD
sudo nmcli con up $SSID
sleep 5
sudo nmcli con up $SSID

sudo nmcli dev wifi rescan
nmcli dev wifi list
```
```
sudo ifconfig wlan0 up
ifconfig wlan0
ifconfig -s wlan0
```

---
### Jetson Nano / Jetson Xavier NX more Memory !!
disable X Window System X11 GUI  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_disable_gui_more_memory/  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_2020_initialize/  

|Xavier NX|used|free|
|:---:|:---:|:---:|
|Before|used 516M|free 6.2G|
|After|used 291M|free 7.0G|

|Nano|used|free|
|:---:|:---:|:---:|
|Before|used 459M|free 2.7G|
|After|used 229M|free 3.3G|
```
# Before used 516M, free 6.2G
free -h
#               total        used        free      shared  buff/cache   available
# Mem:           7.6G        516M        6.2G         29M        874M        6.9G
# Swap:          3.8G          0B        3.8G

systemctl get-default
# graphical.target

# disable X Window System X11 GUI
sudo systemctl set-default multi-user.target

# Reboot
sudo reboot

# After used 291M, free 7.0G
free -h
#               total        used        free      shared  buff/cache   available
# Mem:           7.6G        291M        7.0G         19M        321M        7.1G
# Swap:          3.8G          0B        3.8G

# Enable X Window System X11 GUI
sudo systemctl set-default graphical.target
sudo reboot
```
```
# Temporarily disable X Window System X11 GUI
sudo systemctl isolate multi-user
```
```
# Temporarily disable X Window System X11 GUI
cd
bash ./Jetson_Convenience_Script/JetPack/more_Memory_disable_GUI.sh
```

---
### Jetson Nano / Jetson Xavier NX Make swap 6GB and Disable nvzramconfig zram swap
Make swap 6GB and Disable nvzramconfig zram swap  
```
cd
bash ./Jetson_Convenience_Script/JetPack/make_swap_6gb.sh
```

---
### Jetson Xavier NX M.2 NVMe SSD
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_xavier_nx_install_m2_nvme_ssd/  
```
# Format SSD Device to GPT Linux filesystem
cd
bash ./Jetson_Convenience_Script/Xavier_NX_M2_NVMe_SSD/format_m2_nvme_ssd.sh

# Mount SSD Device Add UUID to fstab
bash ./Jetson_Convenience_Script/Xavier_NX_M2_NVMe_SSD/mount_fstab_m2_nvme_ssd.sh

sudo reboot

df -h
# /dev/nvme0n1p1  469G   73M  445G   1% /jetson_ssd
```

### Jetson Xavier NX Booting from M.2 NVMe SSD
Jetson Xavier NX - Run from SSD  
https://www.jetsonhacks.com/2020/05/29/jetson-xavier-nx-run-from-ssd/  
```
# Format SSD Device to GPT Linux filesystem
cd
bash ./Jetson_Convenience_Script/Xavier_NX_M2_NVMe_SSD/format_m2_nvme_ssd.sh

# Jetson Xavier NX Booting from M.2 NVMe SSD
bash ./Jetson_Convenience_Script/Xavier_NX_M2_NVMe_SSD/boot_from_m2_nvme_ssd.sh

sudo reboot

# Boot from M.2 NVMe SSD
mount | grep nvme
# Mount NVMe to / root
# /dev/nvme0n1p1 on /
```
```
# Disable NVMe Boot
# (Change to Boot from SD-Card)
sudo wipefs /dev/nvme0n1
sudo wipefs --all --force /dev/nvme0n1
sudo reboot
```

### Disk Speed Benchmark M.2 NVMe SSD vs SD-Card

| Device | Seq. Read |
|:---:|:---:|
|M.2 NVMe SSD|1576.45 MB/sec|
|SD-Card|85.49 MB/sec|
```
# Speed Benchmark M.2 NVMe SSD vs SD-Card
sudo apt install -y hdparm

sudo hdparm -t /dev/nvme0n1
# /dev/nvme0n1:
#  Timing buffered disk reads: 4730 MB in  3.00 seconds = 1576.45 MB/sec

sudo hdparm -t /dev/mmcblk0
# /dev/mmcblk0:
#  Timing buffered disk reads: 258 MB in  3.02 seconds =  85.49 MB/sec
```
#### Dump Disk Sector
#### Wipe Bulk Erase Disk Sector
#### Wipe Erase Disk Partition
more Information to  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_xavier_nx_install_m2_nvme_ssd/  

---
### Jetson Nano / Jetson Xavier NX initialize
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_xavier_nx_2020_initialize/  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_2020_initialize/  
```
# Auto detect Nano or Xavier
cd
git clone https://github.com/FREEWING-JP/Jetson_Convenience_Script --depth 1
cd
bash ./Jetson_Convenience_Script/JetPack/1st_jetson_initialize.sh
```
```
source .bashrc
 or 
sudo reboot
```
```
# sudo visudo
sudo visudo
Defaults        env_reset, timestamp_timeout=-1
 or 
echo 'Defaults env_reset, timestamp_timeout=-1' | sudo EDITOR='tee -a' visudo
```
### Optional deb package
```
cd
git clone https://github.com/FREEWING-JP/Jetson_Convenience_Script 00_deb -b 00_deb
mv ./00_deb/00_deb/* ./00_deb/
# */
ls -l ./00_deb
---
OpenCV-4.4.0-aarch64-dev.deb
OpenCV-4.5.1-aarch64-dev.deb
bazel_372.zip
cmake-3.17.5-Linux-aarch64.deb
cmake-3.19.4-Linux-aarch64.deb
```
---
### CMake 3.19.4/ CMake 3.17.5
https://github.com/Kitware/CMake  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_newest_cmake/  
```
# CMake 3.19.4
# for Build OpenPose
cd
bash ./Jetson_Convenience_Script/CMake/inst_CMake.sh

# Create .deb install package
bash ./Jetson_Convenience_Script/CMake/create_CMake_deb.sh
```
```
# CMake 3.17.5
# for Build OpenPose
cd
bash ./Jetson_Convenience_Script/CMake/inst_CMake_3175.sh
```

### libjpeg-turbo 2.0.5 (libjpeg v8)
https://github.com/libjpeg-turbo/libjpeg-turbo  
http://lfsbookja.osdn.jp/BLFS/svn-ja/general/libjpeg.html  
-D WITH_JPEG8=ON  This switch enables compatibility with libjpeg version 8 .  
https://libjpeg-turbo.org/About/TurboJPEG  
"libjpeg-turbo" != "TurboJPEG"  
```
cd
bash ./Jetson_Convenience_Script/libjpeg-turbo/inst_libjpeg-turbo_205.sh
```

### OpenBLAS develop
https://github.com/xianyi/OpenBLAS  
```
cd
bash ./Jetson_Convenience_Script/OpenBLAS/inst_OpenBLAS.sh
```

---
### Bazel 4.0.0/ Bazel 3.7.2/ Bazel 3.5.0
https://bazel.build/  
https://github.com/bazelbuild/bazel/tree/3.5.0  
```
# Bazel 4.0.0
cd
bash ./Jetson_Convenience_Script/Bazel/inst_Bazel_400.sh
```
```
# Bazel 3.7.2
cd
bash ./Jetson_Convenience_Script/Bazel/inst_Bazel_372.sh
```
```
# Bazel 3.5.0
cd
bash ./Jetson_Convenience_Script/Bazel/inst_Bazel_350.sh
```

---
### OpenCV 3.x
https://github.com/opencv/opencv  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_build_opencv_3410/  
```
# OpenCV 3.4.10
cd
bash ./Jetson_Convenience_Script/OpenCV/inst_OpenCV3410.sh
```
```
# OpenCV 3.4.9
cd
bash ./Jetson_Convenience_Script/OpenCV/inst_OpenCV349.sh
```

### OpenCV 4.5.1 with cuDNN 8.0, GStreamer, V4L Video4Linux
```
cd
bash ./Jetson_Convenience_Script/OpenCV/inst_OpenCV451.sh

# Create .deb install package
bash ./Jetson_Convenience_Script/OpenCV/create_OpenCV_deb.sh
```

### OpenCV 4.4.0 with cuDNN 8.0, GStreamer, V4L Video4Linux
```
cd
bash ./Jetson_Convenience_Script/OpenCV/inst_OpenCV440.sh
```

---
### Caffe master
#### JetPack 4.4 production release L4T 32.4.3 Can't build Caffe and OpenPose with cuDNN 8.0  
https://github.com/BVLC/caffe  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_build_caffe_google_deep_dream/  

| JetPack | USE_CUDNN=1 | USE_CUDNN=0 |
|:---:|:---:|:---:|
|4.5 or later|NG|OK|
|4.4.1 PR|NG|OK|
|4.4 PR|NG|OK|
|4.4 DP|OK|OK|
|4.3 PR|OK|OK|
```
# with OpenCV 3.x (JetPack 4.2)
# with OpenCV 4.x (JetPack 4.3 or 4.4)
# Auto detect OpenCV 3.x/ 4.x with OpenCV 4.x patch
# support JetPack 4.4 production release disable cuDNN
cd
bash ./Jetson_Convenience_Script/Caffe/inst_Caffe.sh
```
```
# Special adapted for OpenCV 4.1 and Python 3.6+
# https://github.com/Qengineering/caffe
# Install OpenCV 4.1.2 and Caffe on Ubuntu 18.04 for Python 3
# https://qengineering.eu/install-caffe-on-ubuntu-18.04-with-opencv-4.1.html
# with OpenCV 4.x
cd
bash ./Jetson_Convenience_Script/Caffe/inst_Caffe_Qengineering.sh
```
```
# Caffe installation on Xavier
# https://forums.developer.nvidia.com/t/caffe-installation-on-xavier/67730
# with OpenCV 3.x
cd
bash ./Jetson_Convenience_Script/Caffe/inst_Caffe_NVIDIA.sh
```

### Caffe Deep Dreamer (Google's DeepDream)
https://github.com/kesara/deepdreamer  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_build_caffe_google_deep_dream/  
```
# Auto detect Python 2/ Python 3 with Python 2 patch
cd
bash ./Jetson_Convenience_Script/Caffe/inst_DeepDreamer.sh
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/DeepDreamer_gfl.jpg_8.jpg" alt="Jetson Caffe Deep Dreamer" title="Jetson Caffe Deep Dreamer" width="320" height="240"> _ <img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/DeepDreamer_sky800x449px.jpg_6.jpg" alt="Jetson Caffe Deep Dreamer" title="Jetson Caffe Deep Dreamer" width="320" height="240">  

---
### OpenPose v1.7.0
Support cuDNN 8.0 and OpenCV 4.x  

| JetPack | OpenPose builtin Caffe | external Caffe | external NVIDIA Caffe v0.17.4 |
|:---:|:---:|:---:|:---:|
|4.5|OK (with cuDNN)|No support|OK (with cuDNN)|
```
# Auto detect JetPack 4.3 or 4.4 or 4.5
# Auto detect OpenCV 4.x for Build OpenPose's Caffe
# Require CMake Version 3.12 or above
# support JetPack 4.4 production release with cuDNN 8.0
cd
bash ./Jetson_Convenience_Script/OpenPose/inst_OpenPose.sh
```

### OpenPose v1.6.0
#### JetPack 4.4 production release L4T 32.4.3 Can't build Caffe and OpenPose with cuDNN 8.0  
https://github.com/CMU-Perceptual-Computing-Lab/openpose  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_2020_build_openpose/  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_xavier_nx_2020_build_openpose/  

| JetPack | OpenPose builtin Caffe | external Caffe | external NVIDIA Caffe v0.17.3 |
|:---:|:---:|:---:|:---:|
|4.5 or later|OK (without cuDNN)|NG (without cuDNN)|OK (without cuDNN)|
|4.4.1 PR|OK (without cuDNN)|NG (without cuDNN)|OK (without cuDNN)|
|4.4 PR|OK (without cuDNN)|NG (without cuDNN)|OK (without cuDNN)|
|4.4 DP|OK|NG|OK|
|4.3 PR|OK|NG|OK|
```
# Auto detect JetPack 4.3 or 4.4
# Auto detect OpenCV 3.x/ 4.x for Build OpenPose's Caffe
# external Caffe version should be 0.17.3 (ex. OpenPose internal/ NVIDIA Caffe)
# Require CMake Version 3.12 or above
# support JetPack 4.4 production release without cuDNN 8.0
cd
bash ./Jetson_Convenience_Script/OpenPose/inst_OpenPose_160.sh
```
<img src="https://img.youtube.com/vi/TyokrHR_S_8/maxresdefault.jpg" alt="OpenPose v1.6.0 Detecting human skeleton NVIDIA Jetson Xavier NX JetPack 4.4" title="OpenPose v1.6.0 Detecting human skeleton NVIDIA Jetson Xavier NX JetPack 4.4" width="320" height="180"> _ 
[YouTube https://youtu.be/TyokrHR_S_8](https://youtu.be/TyokrHR_S_8)

### OpenPose Benchmark Comparison Jetson Xavier NX vs Jetson Nano
JetPack 4.4 PR + OpenPose v1.6.0 USE_CUDNN=0  
|net_resolution|Nano|Xavier NX|
|:---:|:---:|:---:|
|240x-1|126 sec|108 sec|
|320x-1|206 sec|116 sec|
|480x-1|456 sec|137 sec|
|512x-1|Killed|154 sec|
|640x-1|Killed|243 sec|
|none|Killed|254 sec|

```
Movie Spec:
Resolution: 1280x720 px
Frame rate: 25 fps
Duration: 14 sec
Total frame: 350 frame

Original Movie from Pixabay:
https://pixabay.com/videos/id-1643/

Command Line:
./build/examples/openpose/openpose.bin --video 'India - 1643.mp4' --display 0 --model_folder ./models --write_video India_out.mp4 --net_resolution 240x-1
#  --net_resolution xxxxx
```

---
### tf-pose-estimation master
https://github.com/ildoonet/tf-pose-estimation  
https://github.com/gsethi2409/tf-pose-estimation  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_jetpack_tf_pose_estimation_setup/  
```
# with TensorFlow v1.x
cd
bash ./Jetson_Convenience_Script/tf-pose-estimation/inst_tf-pose-estimation.sh
```
```
# with TensorFlow v2.x
# https://github.com/gsethi2409/tf-pose-estimation
cd
bash ./Jetson_Convenience_Script/tf-pose-estimation/inst_tf-pose-estimation_tf_v2.sh
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/tf-pose-estimation_p3_org.png" alt="Jetson tf-pose-estimation" title="Jetson tf-pose-estimation" width="320" height="240"> _ <img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/tf-pose-estimation_p3_graph.png" alt="Jetson tf-pose-estimation" title="Jetson tf-pose-estimation" width="320" height="240">  

---
### StyleGAN
https://github.com/NVlabs/stylegan  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_tensorflow_stylegan/  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_tensorflow_stylegan_pretty_anime_face/  
```
# with TensorFlow v1.x
cd
bash ./Jetson_Convenience_Script/StyleGAN/inst_StyleGAN.sh
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/StyleGAN_figure12-uncurated-cats_2b.jpg" alt="Jetson StyleGAN" title="Jetson StyleGAN" width="320" height="240">  

### StyleGAN2
https://github.com/NVlabs/stylegan2  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_tensorflow_stylegan2/  
```
# with TensorFlow v1.x
cd
bash ./Jetson_Convenience_Script/StyleGAN2/inst_StyleGAN2.sh
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/StyleGAN2_grid_1.jpg" alt="Jetson StyleGAN2" title="Jetson StyleGAN2" width="320" height="240"> _ <img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/StyleGAN2_nvidia_jetson_nano_tensorflow_stylegan2_4.jpg" alt="Jetson StyleGAN2" title="Jetson StyleGAN2" width="320" height="240">  

---
### trt_pose
https://github.com/NVIDIA-AI-IOT/trt_pose  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_trt_pose/  
```
# Require Pytorch
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_8_Python3.sh

# Require JupyterLab or Jupyter Notebook
bash ./Jetson_Convenience_Script/Jupyter/inst_Jupyter_Notebook.sh

# trt_pose
cd
bash ./Jetson_Convenience_Script/trt_pose/inst_trt_pose.sh
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/trt_pose.png" alt="trt_pose" title="trt_pose" width="320" height="240">  

---
### trt_pose_hand
https://github.com/NVIDIA-AI-IOT/trt_pose_hand  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_trt_pose_hand/  
```
# Require Pytorch
# Require JupyterLab or Jupyter Notebook
# Require trt_pose
# trt_pose_hand
cd
bash ./Jetson_Convenience_Script/trt_pose_hand/inst_trt_pose_hand.sh
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/trt_pose_hand.png" alt="trt_pose_hand" title="trt_pose_hand" width="320" height="240">  

---
### trt_pose_demo
A Demo Application for NVIDIA TensorRT Pose Estimation  
https://github.com/MACNICA-CLAVIS-NV/trt_pose_demo  
```
# Require Pytorch
# Require trt_pose

# trt_pose_demo
cd
bash ./Jetson_Convenience_Script/trt_pose_demo/inst_trt_pose_demo.sh
```
<img src="https://img.youtube.com/vi/Rr4mOH-6f9g/maxresdefault.jpg" alt="trt_pose_demo Jetson Xavier A Demo Application for NVIDIA TensorRT Pose Estimation" title="trt_pose_demo Jetson Xavier A Demo Application for NVIDIA TensorRT Pose Estimation" width="320" height="180"> _ 
[YouTube https://youtu.be/Rr4mOH-6f9g](https://youtu.be/Rr4mOH-6f9g)

---
### OpenPifPaf 0.12.5 / 0.12.2 / 0.11.9
https://github.com/vita-epfl/openpifpaf  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_install_openpifpaf/  
```
# OpenPifPaf 0.12.5
# Require Pytorch >= 1.7.1
cd
bash ./Jetson_Convenience_Script/openpifpaf/inst_openpifpaf_0125.sh

# OpenPifPaf 0.12.2
# Require Pytorch >= 1.7.1
cd
bash ./Jetson_Convenience_Script/openpifpaf/inst_openpifpaf_0122.sh

# OpenPifPaf 0.11.9
# Require Pytorch >= 1.3.1
cd
bash ./Jetson_Convenience_Script/openpifpaf/inst_openpifpaf_0119.sh
```
```
# OpenPifPaf Image Human Pose Estimation
python3 -m openpifpaf.predict ashinari_369878.jpg --long-edge 641 --image-min-dpi=200 --show-file-extension=jpg --image-output

# OpenPifPaf Movie Human Pose Estimation
VIDEO_FILE="'India - 1643.mp4'"
python3 -m openpifpaf.video --source=$VIDEO_FILE --long-edge 641 --video-output video_$VIDEO_FILE
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/openpifpaf_000000081988.jpg.predictions.jpg" alt="OpenPifPaf" title="OpenPifPaf" width="320" height="240">  

写真素材足成 >  人物 >  ナベ散歩  
http://www.ashinari.com/2012/09/13-369878.php?  
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/openpifpaf_ashinari_369878.jpg.predictions.jpg" alt="OpenPifPaf" title="OpenPifPaf" width="212" height="320">  
<img src="https://img.youtube.com/vi/TTfejnA4yxA/hqdefault.jpg" alt="OpenPifPaf with NVIDIA Jetson Nano developer kit Detecting human skeleton from video" title="OpenPifPaf with NVIDIA Jetson Nano developer kit Detecting human skeleton from video" width="320" height="180"> _ 
[YouTube https://youtu.be/TTfejnA4yxA](https://youtu.be/TTfejnA4yxA)

---
### NVIDIA Caffe v0.17.4
Support cuDNN 8.0 and OpenCV 4.x  

| JetPack | USE_CUDNN=1 | USE_CUDNN=0 |
|:---:|:---:|:---:|
|4.5 or later|OK|OK|

```
# with OpenCV 4.x (JetPack 4.3 or 4.4 or 4.5)
# Auto detect OpenCV 4.x
# support JetPack 4.4 production release enable cuDNN
cd
bash ./Jetson_Convenience_Script/NV_Caffe/inst_NV_Caffe.sh
```

### NVIDIA Caffe v0.17.3
#### JetPack 4.4 production release L4T 32.4.3 Can't build Caffe and OpenPose with cuDNN 8.0  
https://github.com/nvidia/caffe  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_build_nvcaffe_google_deep_dream/  

| JetPack | USE_CUDNN=1 | USE_CUDNN=0 |
|:---:|:---:|:---:|
|4.5 or later|NG|OK|
|4.4.1 PR|NG|OK|
|4.4 PR|NG|OK|
|4.4 DP|OK|OK|
|4.3 PR|OK|OK|
```
# with OpenCV 3.x (JetPack 4.2)
# with OpenCV 4.x (JetPack 4.3 or 4.4)
# Auto detect OpenCV 3.x/ 4.x with OpenCV 4.x patch
# support JetPack 4.4 production release disable cuDNN
cd
bash ./Jetson_Convenience_Script/NV_Caffe/inst_NV_Caffe_0173.sh
```

### NVIDIA FFmpeg for Jetson Nano
https://github.com/jocover/jetson-ffmpeg  

### NVIDIA FFmpeg for Jetson Xavier NX master
https://developer.nvidia.com/ffmpeg  

### NVIDIA FFmpeg for Jetson Nano / Jetson Xavier NX
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_2020_build_ffmpeg/  
```
# Auto detect Nano or Xavier
cd
bash ./Jetson_Convenience_Script/NV_FFmpeg/inst_NV_FFmpeg.sh

# 2020/09 disable x265
# ffmpeg --enable-libx265
# ERROR: x265 not found using pkg-config
```

---
### TensorFlow
https://github.com/tensorflow/tensorflow  
https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform/index.html  
https://docs.nvidia.com/deeplearning/frameworks/install-tf-jetson-platform-release-notes/tf-jetson-rel.html  
Official TensorFlow for Jetson Nano!  
https://forums.developer.nvidia.com/t/official-tensorflow-for-jetson-nano/71770  
Official TensorFlow for Jetson AGX XavierNX  
https://forums.developer.nvidia.com/t/official-tensorflow-for-jetson-agx-xaviernx/141306  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_jetpack_tensorflow_setup/  

##### TensorFlow Current Version
https://developer.download.nvidia.com/compute/redist/jp/v45/tensorflow/  
```
2021-02-26 16:10:00
tensorflow-1.15.5+nv21.2-cp36-cp36m-linux_aarch64.whl 218MB
tensorflow-2.4.0+nv21.2-cp36-cp36m-linux_aarch64.whl 273MB
```

### TensorFlow v1.x
```
# TensorFlow v1.15.2
# Auto detect JetPack 4.3/ 4.4/ 4.5
cd
bash ./Jetson_Convenience_Script/TensorFlow/inst_tf1.sh
```
### TensorFlow v2.x
```
# TensorFlow v2.1.0
# Auto detect JetPack 4.3/ 4.4/ 4.5
cd
bash ./Jetson_Convenience_Script/TensorFlow/inst_tf2.sh
```
### Build TensorFlow v2.4.1
```
# Build TensorFlow v2.4.1
# Require Bazel 3.7.2
cd
bash ./Jetson_Convenience_Script/TensorFlow/build_TensorFlow_v2_4_1.sh
```

### Pytorch
https://forums.developer.nvidia.com/t/pytorch-for-jetson-version-1-6-0-now-available/72048  

| JetPack | Pytorch 1.4.0 | 1.5.0 | 1.6.0 | 1.7.0 | 1.8.0 |
|:---:|:---:|:---:|:---:|:---:|:---:|
|4.5 or later|--|--|OK|OK|OK|
|4.4.1 PR|--|--|OK|OK|OK|
|4.4 PR|--|--|OK|OK|OK|
|4.4 DP|OK|OK|OK|--|--|
|4.3 PR|OK|OK|OK|--|--|
```
# Pytorch v1.8.0 / torchvision v0.9.0 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_8_Python3.sh
```
```
# Pytorch v1.7.0 / torchvision v0.8.1 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_7_Python3.sh
```
```
# Pytorch v1.6.0 / torchvision v0.7.0 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_6_Python3.sh
```
```
# Pytorch v1.5.0 / torchvision v0.6.0 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_5_Python3.sh
```
```
# Pytorch v1.4.0 / torchvision v0.5.0 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_PyTorch_v1_4_Python3.sh
```

### Build PyTorch 1.7.1
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_pytorch_1_7_1/  

|Jetson Model|Build time|
|:---:|:---:|
|Xavier NX|360min|
|Nano|700min|
```
# Temporarily disable X Window System X11 GUI
cd
bash ./Jetson_Convenience_Script/JetPack/more_Memory_disable_GUI.sh

# gcc 8.4.0
# Recommend use gcc 8.4

# Pytorch v1.7.1 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/build_PyTorch_v1_7_1_Python3.sh

# reboot
sudo reboot

# torchvision v0.8.2 / Python 3.6
cd
bash ./Jetson_Convenience_Script/PyTorch/inst_torchvision_v0_8_2.sh
```

---
### NVIDIA DeepStream SDK
https://developer.nvidia.com/deepstream-sdk  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_install_deep_stream_sdk/  
```
# NVIDIA DeepStream 5.1 SDK
cd
bash ./Jetson_Convenience_Script/DeepStream/inst_deepstream_51.sh
source .bashrc

# NVIDIA DeepStream 5.0 SDK
cd
bash ./Jetson_Convenience_Script/DeepStream/inst_deepstream_50.sh
source .bashrc
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/DeepStream_sample.png" alt="NVIDIA DeepStream SDK Sample" title="NVIDIA DeepStream SDK Sample" width="320" height="240">  

### DeepStream Human Pose Estimation
https://github.com/NVIDIA-AI-IOT/deepstream_pose_estimation  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_install_deep_stream_pose_estimation/  

|Jetson Model|deepstream_pose_estimation_config.txt|Work|
|:---:|:---:|:---:|
|Xavier NX|workspace-size=3000|OK|
|Nano|workspace-size=3000|Killed|
|Nano|workspace-size=2000|OK|
```
# DeepStream Human Pose Estimation
cd
bash ./Jetson_Convenience_Script/DeepStream/inst_deepstream_pose_estimation.sh

# Jetson Nano patch
# deepstream_pose_estimation_config.txt
# Change workspace-size=3000 to 2000
sed -i 's/^workspace-size=3000/workspace-size=2000/' deepstream_pose_estimation_config.txt
```
<img src="https://img.youtube.com/vi/GN1HvM__4gY/maxresdefault.jpg" alt="NVIDIA Jetson Xavier NX DeepStream Human Pose Estimation Sample" title="NVIDIA Jetson Xavier NX DeepStream Human Pose Estimation Sample" width="320" height="180"> _ 
[YouTube https://youtu.be/GN1HvM__4gY](https://youtu.be/GN1HvM__4gY)

---
### JupyterLab or Jupyter Notebook
https://jupyter.org/  
```
# JupyterLab (New) include Jupyter Notebook
# jupyter lab      : 3.0.9
cd
bash ./Jetson_Convenience_Script/Jupyter/inst_JupyterLab.sh

# Jupyter Notebook (classic)
# jupyter-notebook : 6.2.0
cd
bash ./Jetson_Convenience_Script/Jupyter/inst_Jupyter_Notebook.sh
```

---
### DATA BASE
- Redis
- Memcached
- MongoDB
### Redis 6.0.8
https://redis.io/  
```
# Redis
cd
bash ./Jetson_Convenience_Script/Redis/inst_Redis.sh
```

### Memcached 1.6.7
https://memcached.org/  
https://github.com/memcached/memcached  
```
# Memcached
cd
bash ./Jetson_Convenience_Script/Memcached/inst_Memcached.sh
```

### MongoDB 3.x / 4.x
https://www.mongodb.com/  
https://github.com/mongodb/mongo  
**32GB SD-Card is Not Enough to Build MongoDB**
```
# MongoDB 3.6.3-0ubuntu1.1 all
apt search mongodb
sudo apt install -y mongodb
```
```
# MongoDB 3.4.14
# https://github.com/mongodb/mongo/tree/r3.4.14
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_3414.sh
```
```
# MongoDB 3.6.8
# https://github.com/mongodb/mongo/tree/r3.6.8
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_368.sh
```
```
# MongoDB 3.6.20
# https://github.com/mongodb/mongo/tree/r3.6.20
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_3620.sh
```
```
# MongoDB 4.2.0
# https://github.com/mongodb/mongo/tree/r4.2.0
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_420.sh
```
```
# MongoDB 4.2.9
# https://github.com/mongodb/mongo/tree/r4.2.9
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_429.sh
```
```
# MongoDB 4.4.1
# https://github.com/mongodb/mongo/tree/r4.4.1
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_441.sh
```
```
# MongoDB 4.7.0
# https://github.com/mongodb/mongo/tree/r4.7.0
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_470.sh
```

### MongoDB Tools 3.x / 4.x
https://docs.mongodb.com/tools/  
https://github.com/mongodb/mongo-tools  
```
# MongoDB Tools master
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_Tools.sh
```
```
# MongoDB Tools r3.6.20
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_Tools.sh r3.6.20
```
```
# MongoDB Tools r4.0.20
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_Tools.sh r4.0.20
```
```
# MongoDB Tools r4.2.10
cd
bash ./Jetson_Convenience_Script/MongoDB/inst_MongoDB_Tools.sh r4.2.10
```

---
### Visual Studio Code
https://github.com/Microsoft/vscode  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_build_visual_studio_code_oss/  
  
```
# Visual Studio Code 1.53.2
# for Jetson Xavier
cd
bash ./Jetson_Convenience_Script/Visual_Studio_Code/inst_Visual_Studio_Code_1532.sh

# for Jetson Nano
# Download .deb package
# https://code.visualstudio.com/#alt-downloads
```
```
# Visual Studio Code 1.52.1
# for Jetson Xavier
cd
bash ./Jetson_Convenience_Script/Visual_Studio_Code/inst_Visual_Studio_Code_1521.sh
```
```
# Visual Studio Code 1.47.2
# for Jetson Xavier
cd
bash ./Jetson_Convenience_Script/Visual_Studio_Code/inst_Visual_Studio_Code_1472.sh
```
```
# Visual Studio Code 1.35.0
# for Jetson Nano
cd
bash ./Jetson_Convenience_Script/Visual_Studio_Code/inst_Visual_Studio_Code_1350.sh
```

---
### Vino VNC Server
https://developer.nvidia.com/embedded/learn/tutorials/vnc-setup  
https://gitlab.gnome.org/GNOME/vino/  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_enable_vino_vnc_server_headless_mode/  
```
cd
bash ./Jetson_Convenience_Script/Vino_VNC/inst_Vino_VNC.sh

# Password = password
# gsettings set org.gnome.Vino vnc-password $(echo -n 'password'|base64)
```
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_enable_vino_vnc_server_headless_mode_2.png" alt="Jetson Vino VNC Server" title="Jetson Vino VNC Server" width="320" height="240"> _ <img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_enable_vino_vnc_server_headless_mode_9.png" alt="Jetson Vino VNC Server" title="Jetson Vino VNC Server" width="320" height="240">  
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/nvidia_jetson_enable_vino_vnc_server_headless_mode_11.png" alt="Jetson Vino VNC Server" title="Jetson Vino VNC Server" width="320" height="240">  

---
### Benchmark
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_benchmark_full_load/  
```
# UnixBench byte-unixbench
# https://github.com/kdlucas/byte-unixbench
cd
bash ./Jetson_Convenience_Script/Benchmark/inst_UnixBench.sh
```
```
# Benchmarks Targeted for Jetson Xavier NX (Using GPU+2DLA)
# https://github.com/NVIDIA-AI-IOT/jetson_benchmarks
cd
bash ./Jetson_Convenience_Script/Benchmark/inst_jetson_benchmarks.sh
```

---
### Jetson stats
https://github.com/rbonghi/jetson_stats  
```
# Install
sudo -H pip install -U jetson-stats
sudo reboot
```

---
### Jetson Hello AI World
https://developer.nvidia.com/embedded/twodaystoademo  
https://github.com/dusty-nv/jetson-inference  
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_nano_sample_application/  
```
# Building the Project from Source
# https://github.com/dusty-nv/jetson-inference/blob/master/docs/building-repo.md
cd
bash ./Jetson_Convenience_Script/Jetson_Hello_AI_World/inst_Jetson_Hello_AI_World.sh
```

---
### Ubuntu Desktop GNOME Screensaver
http://www.neko.ne.jp/~freewing/raspberry_pi/ubuntsu_desktop_gonome_disable_screen_saver/  
```
# Disable Ubuntu Desktop GNOME Screensaver
gsettings set org.gnome.desktop.lockdown disable-lock-screen true
gsettings set org.gnome.desktop.screensaver lock-enabled false
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false
gsettings set org.gnome.desktop.screensaver idle-activation-enabled false

# Enable Ubuntu Desktop GNOME Screensaver (Unit: sec)
gsettings set org.gnome.desktop.lockdown disable-lock-screen false
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.session idle-delay $((15*60)) && \
gsettings set org.gnome.desktop.screensaver lock-delay 5 && \
gsettings set org.gnome.desktop.screensaver lock-enabled true
```

---
### Build Python 3.9.2/ Python 3.8.8/ Python 3.7.10
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_build_python_3_7_10/  
```
# Build Python 3.9.2
cd
bash ./Jetson_Convenience_Script/Python/build_Python_392.sh

# Build Python 3.8.8
cd
bash ./Jetson_Convenience_Script/Python/build_Python_388.sh

# Build Python 3.7.10
cd
bash ./Jetson_Convenience_Script/Python/build_Python_3710.sh
```

---
### gcc 8.4.0
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_install_gcc_8_4_0/  
```
cd
bash ./Jetson_Convenience_Script/gcc/inst_gcc_840.sh
```

### Clang 10
http://www.neko.ne.jp/~freewing/raspberry_pi/nvidia_jetson_install_gcc_8_4_0/  
```
cd
bash ./Jetson_Convenience_Script/Clang/inst_Clang_10.sh
```

---
### FWinSdCardImager Windows SD-Card Image Read Write App.
http://www.neko.ne.jp/~freewing/software/windows_sd_card_imager/  
https://www.vector.co.jp/soft/winnt/util/se520996.html  
<img src="https://raw.githubusercontent.com/FREEWING-JP/Jetson_Convenience_Script/assets/assets/FWinSdCardImager.png" alt="FWinSdCardImager Windows SD-Card Image Read Write App" title="FWinSdCardImager Windows SD-Card Image Read Write App" width="320" height="240">  

