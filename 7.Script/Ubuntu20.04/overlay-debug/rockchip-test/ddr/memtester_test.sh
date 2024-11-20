#!/bin/bash

RESULT_DIR=/data/rockchip-test
RESULT_LOG=${RESULT_DIR}/memtester.log

mkdir -p ${RESULT_DIR}

#get free memory size
mem_avail_size=$(cat /proc/meminfo | grep MemAvailable | awk '{print $2}')
mem_test_size=$(((mem_avail_size/1024/2)-10))M

#run memtester test
echo "******************* DDR MEMTESTER TEST ******************************"
echo "**************** run: memtester $mem_test_size **********************"
memtester $mem_test_size 2>&1 | tee $RESULT_LOG &

echo "*********** DDR MEMTESTER TEST START, LOG AT $RESULT_LOG ************"
