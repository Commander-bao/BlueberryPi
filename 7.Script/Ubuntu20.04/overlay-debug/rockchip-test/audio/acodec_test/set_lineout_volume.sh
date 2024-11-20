#!/bin/bash

v=$1

echo "Set HPOUT volume, range 0->33"

if [ ! -n "$v" ] ; then
	echo "please enter a volume"
else
	echo "set volume: $v"
	amixer set "Output 2" $v
	amixer get "Output 2"
fi
