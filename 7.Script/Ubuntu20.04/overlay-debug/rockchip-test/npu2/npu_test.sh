#!/bin/bash

DIR_NPU=`dirname $0`

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            NPU TEST                           ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "npu stress test:					1"
echo "npu scale frequency test:			2"
echo "rknn demo test:					3"
echo "***********************************************************"

read -t 30 NPU_CHOICE

npu_stress_test()
{
	bash ${DIR_NPU}/npu_stress_test.sh
}

npu_scale_frequency_test()
{
	bash ${DIR_NPU}/npu_freq_scaling.sh 86400 2
}

rknn_demo_test()
{
	bash ${DIR_NPU}/rknn_demo.sh
}

case ${NPU_CHOICE} in
	1)
		npu_stress_test
		;;
	2)
		npu_scale_frequency_test
		;;
	3)
		rknn_demo_test
		;;
	*)
		echo "not found your input."
		;;
esac
