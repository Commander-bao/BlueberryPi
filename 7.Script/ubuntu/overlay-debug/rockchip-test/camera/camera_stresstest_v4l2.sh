#!/bin/bash

COUNT=1

v4l2-ctl --list-devices > /tmp/.v4l2_list
ISP_VIDEO=($(awk '/rkisp_mainpath/{getline a;print a}' /tmp/.v4l2_list))
CIF_VIDEO=($(awk '/stream_cif/{getline a;print a}' /tmp/.v4l2_list))
USB_VIDEO=($(awk '/usb/{getline a;print a}' /tmp/.v4l2_list))
echo "======================================================="
echo "              Test all Cameras (By v4l2)               "
echo "======================================================="
echo "Found ${#ISP_VIDEO[@]} isp cameras, ${#CIF_VIDEO[@]} cif cameras, ${#USB_VIDEO[@]} usb cameras"


while true;do
	NOW=`date`
	TIME_LABEL="====== Count:$COUNT Time: $NOW ======"
	echo $TIME_LABEL
	COUNT=$(expr $COUNT + 1 )

	for j in ${USB_VIDEO[*]}
		do
		 echo "====== Capture USB Camera Path $j By v4l2 ======"
		 v4l2-ctl -d "$j" --set-fmt-video=width=640,height=480,pixelformat=YUYV --stream-mmap=3 --stream-count=5 --stream-poll --stream-to=/tmp/camera.yuyv

		 size=`ls -l /tmp/camera.yuyv | awk '{print $5}'`
		 if [ $size -eq 3072000 ] ;then
			rm -rf /tmp/camera.yuyv
		 else
			echo "Exit Capture USB Camera: Capture Wrong Size$size"
			exit 1
		 fi
		done

	for i in ISP_VIDEO CIF_VIDEO
	do
		eval value=\${${i}[@]}
		for j in $value
		do
		 echo "====== Capture ISP or CIF Camera Path $j By ======"
		 v4l2-ctl -d "$j" --set-fmt-video=width=640,height=480,pixelformat=NV12 --stream-mmap=3 --stream-count=5 --stream-poll --stream-to=/tmp/camera.nv12
		 size=`ls -l /tmp/camera.nv12 | awk '{print $5}'`

		 if [ $size -eq 2304000 ] ;then
			rm -rf /tmp/camera.nv12
		 else
			echo "Exit Capture ISP or CIF Camera: Capture Wrong Size$size"
			exit 1
		 fi
		done
	done

done
	echo END $TIME_LABEL
