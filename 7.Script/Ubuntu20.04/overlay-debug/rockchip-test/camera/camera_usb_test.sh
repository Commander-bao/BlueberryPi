#!/bin/bash
#export GST_DEBUG=*:5
export DISPLAY=:0.0
#test_camera-uvc.sh > /tmp/1.txt 2>&1
#export GST_DEBUG_FILE=/tmp/2.txt
#echo 600000000 > /sys/kernel/debug/clk/aclk_vcodec/clk_rate
#export GST_MPP_JPEGDEC_DEFAULT_FORMAT=NV12

echo "Start UVC Camera M-JPEG Preview!"

if [ -e "/usr/lib/arm-linux-gnueabihf" ] ;
then
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/arm-linux-gnueabihf/gstreamer-1.0
else
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/aarch64-linux-gnu/gstreamer-1.0
fi

v4l2-ctl --list-devices > /tmp/.v4l2_list
USB_VIDEO=($(awk '/usb/{getline a;print a}' /tmp/.v4l2_list))
echo "Found ${#USB_VIDEO[@]} USB Cameras"
rm /tmp/.v4l2_list

for i in USB_VIDEO
do
	eval value=\${${i}[@]}
	for j in $value
	do
	echo "Start Preview USB Camera Video Path $j By GStreamer"
	gst-launch-1.0 v4l2src device="$j" ! image/jpeg! jpegparse ! mppjpegdec ! xvimagesink sync=false
	done
done
