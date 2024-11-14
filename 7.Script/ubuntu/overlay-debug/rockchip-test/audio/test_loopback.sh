#!/bin/bash

device_1=$1
device_2=$2

prepare_mic_capture()
{
	amixer set "Capture Digital" 192
	amixer set "Capture Mute" 0
	amixer set "Right PGA Mux" "DifferentialR"
	amixer set "Left PGA Mux" "DifferentialL"
	amixer set "Differential Mux" "Line 2"
}

prepare_adc_gains()
{
	adc_mic_gain=$1

	echo "Prepare ADC MIC GAINs with $adc_mic_gain dB"
	# PGA gain
	amixer set "Left Channel" $adc_mic_gain
	amixer set "Right Channel" $adc_mic_gain
}

test_loopback()
{
	# PATH_CAPTURE=/mnt/sdcard/cap_files
	# PATH_CAPTURE=/media/usb0/cap_files
	PATH_CAPTURE=/tmp/cap_files
	play_device="default"
	capt_device="default"
	fs=16000
	capt_bits="S16_LE"
	capt_ch=2
	capt_seconds=60			# capture once per 1min
	capt_minutes=60			# capture minutes
	switch_gain_count=8
	play_seconds=2
	play_start_doze=0.3
	play_stop_doze=1
	play_bits=16
	play_ch=2

	if [ -n "$1" ]; then
		play_device=$1
	fi

	if [ -n "$2" ]; then
		capt_device=$2
	fi

	# play_gain_tbl="-30 -25 -20 -15 -10 -5 0 5 10 15 20 25 30"
	play_gain_tbl="-30"
	set -- $play_gain_tbl
	play_gain_num=$#
	test_hours=5
	let "capt_count=$capt_minutes*$test_hours"		# capture 120 hours
	let "play_count=$capt_seconds/($play_seconds+$play_stop_doze)"

	mkdir -p $PATH_CAPTURE

	echo "play_device: $play_device, capt_device: $capt_device, capt_count: $capt_count, play_count: $play_count, test $test_hours hours on PATH_CAPTURE: $PATH_CAPTURE"

	echo "******** Test loopback start ********"

	prepare_mic_capture

	for capt_cnt in `seq 1 $capt_count`; do
		capt_gain=0
		# playback -> capture -> playback
		sox -b $play_bits -r $fs -c $play_ch -n -t alsa $play_device synth $play_seconds sine 1000 gain -30 &  # do playback
		# start doze
		sleep $play_start_doze

		let "temp=($capt_cnt-1)/($capt_count/$switch_gain_count)"
		let "capt_gain=$temp%(switch_gain_count+1)*3" # step 3dB

		DUMP_FILE=$(printf 'loopback_fs%d_format_%s_ch%d_mic%ddb_%04d.wav' $fs $capt_bits $capt_ch $capt_gain $capt_cnt)
		echo "temp: $temp, capt_gain: $capt_gain DUMP_FILE: $DUMP_FILE"

		prepare_adc_gains $capt_gain

		# echo "capt_cnt: $capt_cnt"
		# echo "play_count: $play_count, play_seconds: $play_seconds"
		echo "arecord -D $capt_device -r $fs -f $capt_bits -c $capt_ch -d $capt_seconds $PATH_CAPTURE/$DUMP_FILE"
		arecord -D $capt_device -r $fs -f $capt_bits -c $capt_ch -d $capt_seconds $PATH_CAPTURE/$DUMP_FILE &  # do capture

		# wait the first playback stop
		sleep $play_seconds

		set -- $play_gain_tbl
		for play_cnt in `seq 1 $play_count`; do
			play_gain=$1
			shift
			let play_gain_index+=1

			# echo "play_gain_index: $play_gain_index, play_gain_num: $play_gain_num"
			echo "sox -b $play_bits -r $fs -c $play_ch -n -t alsa $play_device synth $play_seconds sine 1000 gain $play_gain"
			if [ $play_gain_index -ge $play_gain_num ]; then
				set -- $play_gain_tbl
				play_gain_index=0
			fi
			# echo "play_cnt: $play_cnt"
			sox -b $play_bits -r $fs -c $play_ch -n -t alsa $play_device synth $play_seconds sine 1000 gain $play_gain # do playback
			# stop doze
			sleep $play_stop_doze
		done;
	done;

	echo "******** Test loopback end ********"
}

echo "******** Test loopback v0.1.0 ********"

test_loopback $device_1 $device_2
