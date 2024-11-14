#!/bin/bash

echo "Loop playback $1"

while [ true ]
do
	aplay $1 -r 44100 &
	sleep 2
	/userdata/stop_aplay.sh
	sleep 2
done;
