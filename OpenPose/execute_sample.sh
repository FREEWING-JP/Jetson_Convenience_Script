#!/bin/sh

# ===
echo execute sample Picture --net_resolution -1x240
./build/examples/openpose/openpose.bin -image_dir ./examples/media/ --display 0 --model_folder ./models --write_images ./output/ --net_resolution -1x240

ls -l ./output/

# ===
echo execute sample Video --net_resolution 320x-1
./build/examples/openpose/openpose.bin --video examples/media/video.avi --display 0 --model_folder ./models --write_video output_video.mp4 --net_resolution 320x-1 -fps_max 15

ls -l output_video.mp4

