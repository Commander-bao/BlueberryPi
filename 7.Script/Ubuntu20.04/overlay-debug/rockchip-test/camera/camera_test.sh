#!/bin/bash

DIR_CAMERA=`dirname $0`

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***                CAMERA TEST                    ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "*****************************************************"
echo "camera rkisp test:                                  1"
echo "camera usb test:                                    2"
echo "camera stresstest by v4l2:                          3"
echo "camera stresstest by rkisp_demo:                    4"
echo "*****************************************************"

read -t 30 CAMERA_CHOICE

camera_rkisp_test()
{
	bash ${DIR_CAMERA}/camera_rkisp_test.sh
}

camera_usb_test()
{
	bash ${DIR_CAMERA}/camera_usb_test.sh
}

camera_stresstest_v4l2()
{
	bash ${DIR_CAMERA}/camera_stresstest_v4l2.sh
}

camera_stresstest_rkisp_demo()
{
	bash ${DIR_CAMERA}/camera_stresstest_rkisp_demo.sh
}

case ${CAMERA_CHOICE} in
	1)
		camera_rkisp_test
		;;
	2)
		camera_usb_test
		;;
	3)
		camera_stresstest_v4l2
		;;
	4)
		camera_stresstest_rkisp_demo
		;;
	*)
		echo "not found your input."
		;;
esac
