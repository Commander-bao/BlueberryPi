#!/bin/bash

CURRENT_DIR=`dirname $0`

export DDR_CHOICE

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            DDR TEST                           ***"
    echo "***                                               ***"
    echo "*****************************************************"
    echo "*****************************************************"
    echo "memtester:                                      1"
    echo "stressapptest:                                  2"
    echo "ddr auto scaling:                               3"
    echo "stressapptest + memtester:                      4"
    echo "stressapptest + memtester + ddr auto scaling:   5"
    echo "*****************************************************"
    read -t 30 -p "please input test moudle: " DDR_CHOICE
}
info_view

memtester_test()
{
	bash ${CURRENT_DIR}/memtester_test.sh &
}

stressapptest_test()
{
	bash ${CURRENT_DIR}/stressapptest_test.sh &
}

ddr_freq_scaling_test()
{
	bash ${CURRENT_DIR}/ddr_freq_scaling.sh &
}

case ${DDR_CHOICE} in
	1)
		memtester_test
		;;
	2)
		stressapptest_test
		;;
	3)
		ddr_freq_scaling_test
		;;
	4)
		stressapptest_test
		memtester_test
		;;
	5)
		stressapptest_test
		memtester_test
		ddr_freq_scaling_test
		;;
	*)
		echo "not found your input. $DDR_CHOICE"
		;;
esac
