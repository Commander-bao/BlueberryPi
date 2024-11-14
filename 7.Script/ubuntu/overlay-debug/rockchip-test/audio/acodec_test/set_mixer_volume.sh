#!/bin/bash

v=$1

echo "Set Mixer volume, range 0->7"

if [ ! -n "$v" ] ; then
	echo "please enter a volume"
else
	echo "set volume: $v"
	amixer set "Left Mixer Left Bypass" $v
	amixer set "Right Mixer Left Bypass" $v
	amixer get "Left Mixer Left Bypass"
	amixer get "Right Mixer Left Bypass"
fi
