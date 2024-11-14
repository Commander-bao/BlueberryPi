#!/bin/bash

CURRENT_DIR=`dirname $0`

info_view()
{
	echo $CURRENT_DIR
	echo "*****************************************************"
	echo "***                                               ***"
	echo "***                 CPU TEST                      ***"
	echo "***                                               ***"
	echo "*****************************************************"
}

info_view
echo "*****************************************************"
echo "stressapptest test:                               1"
echo "cpu auto scaling:                                 2"
echo "stressapptest + cpu auto scaling:                 3"
echo "*****************************************************"

read -t 30 CPUFREQ_CHOICE

cpu_stress_test()
{
	bash ${CURRENT_DIR}/../ddr/stressapptest_test.sh &
}

cpu_freq_scaling_test()
{
	bash ${CURRENT_DIR}/cpu_freq_scaling.sh &
}

case ${CPUFREQ_CHOICE} in
	1)
		cpu_stress_test
		;;
	2)
		cpu_freq_scaling_test
		;;
	3)
		cpu_stress_test
		cpu_freq_scaling_test
		;;
	*)
		echo "not found your input."
		;;
esac
