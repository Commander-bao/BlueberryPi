#!/bin/bash

adc=$1
v=$2
gain_type=digital

if [ -n "$3" ] ; then
	gain_type=$3
fi

echo "Set ADC MIC volume, Digital range 0-192, PGA range 0-8"

case $adc in
	0)
		ch="Left"
		;;
	*)
		ch="Right"
		;;
esac

if [ "$gain_type" == "digital" ] ; then
	ch="All"
fi

echo "Will set $ch $gain_type"

if [ ! -n "$v" ] ; then
	echo "ERR: please enter a volume"
	echo "$0 0 192 digital"
else
	if [ "$gain_type" == "digital" ] ; then
		amixer set "Capture Digital" $v
		amixer get "Capture Digital"
	else
		content="$ch Channel"
		amixer set "$content" $v
		amixer get "$content"
	fi
fi
