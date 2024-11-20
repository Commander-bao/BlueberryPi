#!/bin/bash

set_cpu_freq() {
    echo userspace > $1/scaling_governor
    echo $2 > $1/scaling_setspeed
    cur=`cat $1/scaling_cur_freq`
    if [ "$cur" -eq "$2" ];then
        echo "cpu freq policy:${d##*policy} success change to $cur KHz"
    else
        echo "cpu freq: failed change to $2 KHz, now $cur KHz"
	exit
    fi
}

if [ "$#" -eq "1" ];then
    for d in /sys/devices/system/cpu/cpufreq/*; do
        read -a array < $d/scaling_available_frequencies
        let j=${#array[@]}-1
        for i in `seq 0 $j`; do
            if [ "$1" -eq "${array[$i]}" ];then
                set_cpu_freq $d $1
                exit
            fi
        done
        echo "cpu freq: $1 is not in available frequencies: "${array[*]}""
        echo "cpu freq: now $(cat $d/scaling_cur_freq) Hz"
    done
else
    cnt=0
    RANDOM=$$$(date +%s)
    while true; do
        for d in /sys/devices/system/cpu/cpufreq/*; do
            read -a FREQS < $d/scaling_available_frequencies
            FREQ=${FREQS[$RANDOM % ${#FREQS[@]} ]}
            echo -n "cnt: $cnt, "
            set_cpu_freq $d ${FREQ}
            let "cnt=$cnt+1"
        done
    done
fi
