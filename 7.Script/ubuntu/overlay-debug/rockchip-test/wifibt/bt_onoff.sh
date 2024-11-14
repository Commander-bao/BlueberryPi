#!/bin/bash

function test_bt() {
	wifibt-init.sh
	sleep 5
	hciconfig hci0 up && hciconfig -a | grep UP
	if [ $? -ne 0 ];then
		echo "The bt test fail !!!"
		dmesg > /data/bt_dmesg.txt
		exit 11
	fi
}

function main() {
	while true; do
		test_bt
		sleep 1
		cnt=$((cnt + 1))
	echo "
	#################################################
	# The BT has been tuned on/off for $cnt times   #
	#################################################
	"
	done
}

main
