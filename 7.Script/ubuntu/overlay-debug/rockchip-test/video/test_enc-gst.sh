#!/bin/sh
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt
export mpp_syslog_perror=1

echo "message: output to /home/cat/2k.ts!"

gst-launch-1.0 videotestsrc num-buffers=512 ! video/x-raw,format=NV12,width=1920,height= 1080,framerate=30/1 \
    ! queue ! mpph264enc ! queue ! h264parse ! mpegtsmux ! filesink location=/home/cat/2k.ts

echo "message: playing encoded video!"

gst-launch-1.0 uridecodebin uri=file:///home/cat/2k.ts  ! xvimagesink
