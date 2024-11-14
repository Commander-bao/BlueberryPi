#!/bin/bash

RESULT_DIR=/userdata/rockchip-test/
RESULT_LOG=${RESULT_DIR}/suspend_resume.txt
SUSPEND_MAX=60
SUSPEND_MIN=30
SUSPEND_INTERVAL=$(($SUSPEND_MAX - $SUSPEND_MIN + 1 ))
WAKE_MAX=60
WAKE_MIN=30
WKAE_INTERVAL=$(($WAKE_MAX - $WAKE_MIN + 1 ))
MAX_CYCLES=10000

if [ ! -e "/sys/class/rtc/rtc0/wakealarm" ];then
    echo "non-existent rtc, please check if rtc enabled"
    exit
fi

mkdir -p ${RESULT_DIR}

random() {
  hexdump -n 2 -e '/2 "%u"' /dev/urandom
}

auto_suspend_resume_rtc()
{
    cnt=0

    # set sys time same with rtc
    hwclock --systohc
    hwclock -w
    echo "$(date): auto_suspend_resume_rtc start" > ${RESULT_LOG}

    while true; do
        echo "have done $cnt suspend/resume"
        if [ $cnt -ge $MAX_CYCLES ]
        then
            echo "run $MAX_CYCLES cycles, finish test"
            exit 0
        fi
        sus_time=$(( ( $(random) % $SUSPEND_INTERVAL ) + $SUSPEND_MIN ))
        echo "sleep for $sus_time second"
        echo 0 > /sys/class/rtc/rtc0/wakealarm
        echo "+${sus_time}" > /sys/class/rtc/rtc0/wakealarm
        pm-suspend
        wake_time=$(( ( $(random) % $WKAE_INTERVAL ) + $WAKE_MIN ))
        echo "wake for $wake_time second"
        sleep $wake_time
        echo "$(date): Count: $cnt - sleep: $sus_time wake: $wake_time " >> ${RESULT_LOG}
        let "cnt=$cnt+1"
    done
}
auto_suspend_resume_rtc

