#!/bin/sh
export DISPLAY=:0.0
#export GST_DEBUG=*:5
#export GST_DEBUG_FILE=/tmp/2.txt
export mpp_syslog_perror=1
# xv vo
mpv --hwdec=rkmpp --vd-lavc-software-fallback=no --vo=xv /usr/local/test.mp4

# x11egl + drm overlay
mpv --hwdec=rkmpp --vo=opengl --gpu-hwdec-interop=drmprime-drm --gpu-context=x11egl /usr/local/test.mp4
