#!/bin/bash

RESULT_DIR=/data/rockchip-test
RESULT_LOG=${RESULT_DIR}/stressapptest.log

mkdir -p ${RESULT_DIR}

#get free memory size
mem_avail_size=$(cat /proc/meminfo | grep MemAvailable | awk '{print $2}')
mem_test_size=$(((mem_avail_size/1024/2)-10))

#run stressapptest_test
echo "*************************** DDR STRESSAPPTEST TEST 24H ***************************************"
echo "**run: stressapptest -s 86400 -i 4 -C 4 -W --stop_on_errors -M $mem_test_size -l $RESULT_LOG**"

stressapptest -s 86400 -i 4 -C 4 -W --stop_on_errors -M $mem_test_size -l $RESULT_LOG &

echo "************************** DDR STRESSAPPTEST START, LOG AT $RESULT_LOG ************************"
