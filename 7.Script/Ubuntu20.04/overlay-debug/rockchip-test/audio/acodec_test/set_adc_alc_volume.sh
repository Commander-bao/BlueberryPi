#!/bin/bash

v=$1

echo "Set ALC capture volume, volume range 0->15"

if [ ! -n "$v" ] ; then
	echo "ERR: please enter a volume"
else
	amixer set "ALC Capture Target" $v
	amixer get "ALC Capture Target"
fi
