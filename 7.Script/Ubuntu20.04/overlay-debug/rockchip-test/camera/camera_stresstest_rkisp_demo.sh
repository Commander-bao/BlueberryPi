#!/bin/bash
echo "======================================================="
echo "            Test all Cameras (By rkisp_demo)           "
echo "======================================================="
#num is test times
COUNT=1
#cam link num
CAM_NUM=0;
#media node max
MEDIA_MAX=20;
#cif path node name
CIF_PATH="stream_cif"
#isp path node name
ISP_PATH="rkisp_mainpath"
for i in $(seq 0 $MEDIA_MAX); do
	MEDIA_DEV=/dev/media$i
	ISP_NODE=$(media-ctl -d $MEDIA_DEV -e $ISP_PATH)
	CIF_NODE=$(media-ctl -d $MEDIA_DEV -e $CIF_PATH)
	Link=$(media-ctl -d $MEDIA_DEV -p | grep "0 link")

	if echo $ISP_NODE | grep -q "^/dev/video"
	then
		CAM_NUM=$(($CAM_NUM + 1));
		eval VIDEO_NODE$i=$ISP_NODE;
		echo "     Check /dev/media$i is ISP-camera($(eval echo \$VIDEO_NODE$i))"
	elif echo $CIF_NODE | grep -q "^/dev/video"
	then
		CAM_NUM=$(($CAM_NUM + 1));
		if echo $Link | grep -q "0 link"
		then
			CAM_NUM=$(($CAM_NUM - 1));
			eval VIDEO_NODE$i="";
			echo "     Check /dev/media$i didn't link anycamera($(eval echo \$VIDEO_NODE$i)) "
		else
			eval VIDEO_NODE$i=$CIF_NODE;
			echo "     Check /dev/media$i is CIF-camera($(eval echo \$VIDEO_NODE$i))"
		fi
	else
		VID_NUM=$i;
		echo ""
		echo "     Test camera(Cam_num=$CAM_NUM) times"
		echo "======================================================="
	#	break;
	fi
done
VID_NUM=$(($VID_NUM -1));

while true;do
	NOW=`date`
	TIME_LABEL="====== Count:$COUNT Time: $NOW ======"
	echo $TIME_LABEL
	COUNT=$(expr $COUNT + 1 )
	i=0;
	for i in $(seq 0 $CAM_NUM); do
		VIDEO_DEV=$(eval echo \$VIDEO_NODE$i);
		if echo $VIDEO_DEV | grep -q "^/dev/video"
		then
			rkisp_demo --device=$VIDEO_DEV --stream-to=/tmp/video$i.yuv --count=100;
			echo "======================================================="
			echo " camera $(eval echo \$VIDEO_NODE$i) No.($TEST_NUM) out /tmp/video$i.yuv is ok!";
			echo "======================================================="
			sleep 1;
		fi
	done;
done
	echo END $TIME_LABEL

