#!/bin/bash -e

#apt update
#apt install -y libqt5webengine5 qtwebengine5-examples
export mpp_syslog_perror=1

echo performance | tee $(find /sys/ -name *governor)
echo 0x100 > /sys/module/rk_vcodec/parameters/mpp_dev_debug

if [ -e "/usr/lib/aarch64-linux-gnu/qt5/examples/webenginewidgets/simplebrowser" ] ;
then
	cd /usr/lib/aarch64-linux-gnu/qt5/examples/webenginewidgets/simplebrowser
	./simplebrowser
	#./simplebrowser https://www.baidu.com
	#./simplebrowser "file:///oem/SampleVideo_1280x720_5mb.mp4"
else
	echo "Please sure install the qtwebengine5-examples....."
fi
echo "the governor is performance for now, please restart it........"
