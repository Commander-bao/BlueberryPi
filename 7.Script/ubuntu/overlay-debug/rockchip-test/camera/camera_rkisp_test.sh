#!/bin/bash
#export GST_DEBUG=*:5
#export GST_DEBUG=ispsrc:5
#export GST_DEBUG_FILE=/tmp/2.txt
export DISPLAY=:0.0

if [ -e "/usr/lib/arm-linux-gnueabihf" ] ;
then
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/arm-linux-gnueabihf/gstreamer-1.0
else
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/aarch64-linux-gnu/gstreamer-1.0
fi

echo "Start RKISP Camera Preview!"
gst-launch-1.0 v4l2src device=/dev/video-camera0 ! video/x-raw,format=NV12,width=640,height=480, framerate=30/1 ! xvimagesink
#gst-launch-1.0 v4l2src device=/dev/video1 ! video/x-raw, format=NV12, width=640, height=480, framerate=30/1 ! kmssink

#grep '' /sys/class/video4linux/video*/name
