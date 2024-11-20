#!/bin/bash

if [ -d "/mnt/udisk/videos" ];then
	TEST_DIR=/mnt/udisk/videos
else
	if [ -d "/userdata/videos" ];then
		TEST_DIR=/userdata/videos
	else
		echo "Please put test videos in directory: /mnt/udsik/videos or /userdata/videos"
		exit 1
	fi
fi


COUNT=1
while true;
do
	TIME_LABEL="====== Count:$COUNT Time: $NOW ======"
	echo $TIME_LABEL
	COUNT=$(expr $COUNT + 1 )
	echo $TEST_DIR '$TEST_DIR' "$TEST_DIR" ${TEST_DIR}
	gst-play-1.0 --flags=3 $TEST_DIR
	sleep 1
done
