#!/bin/bash

cd `dirname $0`
pwd
SCRIPT_DIR=$(pwd)
echo $SCRIPT_DIR

# ===
# OpenCV Haar Cascade Object Detection
# http://www.neko.ne.jp/~freewing/raspberry_pi/raspberry_pi_opencv_haar_cascade_face_detector/


#
cd
mkdir Face
cd Face

# Python3
# pip3 install numpy
# pip3 install opencv-python

#
wget https://github.com/opencv/opencv/raw/master/data/haarcascades/haarcascade_frontalface_default.xml
wget https://github.com/opencv/opencv/raw/master/data/haarcascades/haarcascade_eye.xml

# Original error was: libf77blas.so.3: cannot open shared object file: No such file or directory
sudo apt-get -y install libatlas-base-dev

# ImportError: libjasper.so.1: cannot open shared object file: No such file or directory
sudo apt-get -y install libjasper-dev

# ImportError: libQtGui.so.4: cannot open shared object file: No such file or directory
sudo apt-get -y install libqtgui4

# ImportError: libQtTest.so.4: cannot open shared object file: No such file or directory
sudo apt-get -y install libqt4-test

# libgtk2.0-dev GTK+ 2.x or Carbon support function cvShowImage
sudo apt install libgtk2.0-dev

cp $SCRIPT_DIR/face.py .


# ===
cd
cd Face

# ===
# Camera
if [ ! -e /dev/video0 ]; then
  echo "No Camera Error"
  exit 1
fi
if [ -e /dev/video2 ]; then
  sed -i 's/cv2.VideoCapture(0)/cv2.VideoCapture(2)/' face.py
fi
if [ -e /dev/video1 ]; then
  sed -i 's/cv2.VideoCapture(0)/cv2.VideoCapture(1)/' face.py
fi

echo "Raspberry Pi Camera not Working"
python3 face.py


# ===
# ===
# Need GUI env.
# jetson@linux:~/Face $ python3 face.py
# [ WARN:0] OpenCV | GStreamer warning: Cannot query video position: status=0, value=-1, duration=-1
# (python3:8294): Gtk-WARNING **: 20:59:56.202: cannot open display:

# ===
# ===
# OpenCV Wrong Build Settings
# [ WARN:0] OpenCV | GStreamer warning: GStreamer: pipeline have not been created
# Traceback (most recent call last):
#   File "face.py", line 27, in <module>
#     cv2.imshow('img',img)
# cv2.error: OpenCV(3.4.10) /home/jetson/opencv_34/opencv/modules/highgui/src/window.cpp:658: error: (-2:Unspecified error) The function is not implemented. Rebuild the library with Windows, GTK+ 2.x or Carbon support. If you are on Ubuntu or Debian, install libgtk2.0-dev and pkg-config, then re-run cmake or configure script in function 'cvShowImage'

# ===
# ===
# Raspberry Pi Camera not Working
# jetson@linux:~/Face $ python3 face.py
# [ WARN:0] OpenCV | GStreamer warning: Embedded video playback halted; module v4l2src0 reported: Internal data stream error.
# [ WARN:0] OpenCV | GStreamer warning: unable to start pipeline
# [ WARN:0] OpenCV | GStreamer warning: GStreamer: pipeline have not been created
# Opening in O_NONBLOCKING MODE
# VIDEOIO ERROR: libv4l unable convert to requested pixfmt
# Opening in BLOCKING MODE
# VIDEOIO ERROR: libv4l unable to ioctl VIDIOCSPICT
# Traceback (most recent call last):
#   File "face.py", line 15, in <module>
#     gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
# cv2.error: OpenCV(3.4.10) /home/jetson/opencv_34/opencv/modules/imgproc/src/color.cpp:182: error: (-215:Assertion failed) !_src.empty() in function 'cvtColor'

