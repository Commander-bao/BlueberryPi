#!/bin/bash

DIR_GPU=`dirname $0`

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***                 GPU TEST                      ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "glmark2 fullscreen test:                                 1"
echo "glmark2 normal test (800x600):                           2"
echo "glmark2 offscreen test:                                  3"
echo "glmark2 stress test:                                     4"
echo "***********************************************************"

read -t 30 GPU_CHOICE

glmark2_fullscreen_test()
{
	bash ${DIR_GPU}/test_fullscreen_glmark2.sh
}

glmark2_normal_test()
{
	bash ${DIR_GPU}/test_normal_glmark2.sh
}

glmark2_offscreen_test()
{
	bash ${DIR_GPU}/test_offscreen_glmark2.sh
}

glmark2_stress_test()
{
	bash ${DIR_GPU}/test_stress_glmark2.sh
}

case ${GPU_CHOICE} in
	1)
		glmark2_fullscreen_test
		;;
	2)
		glmark2_normal_test
		;;
	3)
		glmark2_offscreen_test
		;;
	4)
		glmark2_stress_test
		;;
	*)
		echo "not found your input."
		;;
esac
