#!/bin/bash

DIR_CHROMIUM=`dirname $0`

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            CHROMIUM TEST                      ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "Chromium test:						1"
echo "SimpleBrowser test:					2"
echo "***********************************************************"

read -t 30 CHROMIUM_CHOICE

chromium_test()
{
	sh ${DIR_CHROMIUM}/test_chromium_with_video.sh
}

simplebrowser_test()
{
	sh ${DIR_CHROMIUM}/test_simplebrowser.sh
}

case ${CHROMIUM_CHOICE} in
	1)
		chromium_test
		;;
	2)
		simplebrowser_test
		;;
	*)
		echo "not found your input."
		;;
esac
