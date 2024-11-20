#!/bin/bash

usage()
{
echo "Usage: npu_freq_scaling.sh [test_second] [every_freq_stay_second]"
echo "example: npu_freq_test.sh  3600 30"
echo "means npu_freq_test.sh will run 1 hour and every cpu frequency stay 30s"
}

echo "test will run $1 seconds"
echo "every npu frqeucny will stay $2 seconds"

NPU_PATH=/sys/devices/platform/*.npu/devfreq/*.npu

unset FREQS
read -a FREQS < $NPU_PATH/available_frequencies
RANDOM=$$$(date +%s)
time_cnt=0

while true; do
  if [ $time_cnt -ge $1 ]
  then
     echo "======TEST SUCCESSFUL, QUIT====="
     exit 0
  fi

  echo userspace > $NPU_PATH/governor
  FREQ=${FREQS[$RANDOM % ${#FREQS[@]} ]}
  echo "set ddr frequency to $FREQ"
  echo ${FREQ} > $NPU_PATH/userspace/set_freq
  sleep $2
  let "time_cnt=$time_cnt+$2"
done

