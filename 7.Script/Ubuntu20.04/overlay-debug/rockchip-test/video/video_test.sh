#!/bin/bash

DIR_VIDEO=/rockchip-test/video

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            VIDEO TEST                         ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "video test demo:						1"
echo "video test with FPS display demo:				2"
echo "video max FPS test without display demo:			3"
echo "multivideo test:						4"
echo "gstreamer decode test:					5"
echo "mpv player decode test:					6"
echo "parole player decode test:				7"
echo "qt player decode test:					8"
echo "gstreamer encode test:					9"
echo "***********************************************************"

read -t 30 VIDEO_CHOICE

video_test()
{
	bash ${DIR_VIDEO}/test_gst_video.sh
}

video_test_fps()
{
	bash ${DIR_VIDEO}/test_gst_video_fps.sh
}

video_test_maxfps()
{
	bash ${DIR_VIDEO}/test_gst_video_maxfps.sh
}

multivideo_test()
{
	bash ${DIR_VIDEO}/test_gst_multivideo.sh
}

gst_dec_test()
{
	bash ${DIR_VIDEO}/test_dec-gst.sh
}

mpv_dec_test()
{
	bash ${DIR_VIDEO}/test_dec-mpv.sh
}

parole_dec_test()
{
	bash ${DIR_VIDEO}/test_dec-parole.sh
}

qt_dec_test()
{
	bash ${DIR_VIDEO}/test_dec-qt.sh arm64
}

gst_enc_test()
{
	bash ${DIR_VIDEO}/test_enc-gst.sh
}

case ${VIDEO_CHOICE} in
	1)
		video_test
		;;
	2)
		video_test_fps
		;;
	3)
		video_test_maxfps
		;;
	4)
		multivideo_test
		;;
	5)
		gst_dec_test
		;;
	6)
		mpv_dec_test
		;;
	7)
		parole_dec_test
		;;
	8)
		qt_dec_test
		;;
	9)
		gst_enc_test
		;;
	*)
		echo "not fount your input."
		;;
esac
