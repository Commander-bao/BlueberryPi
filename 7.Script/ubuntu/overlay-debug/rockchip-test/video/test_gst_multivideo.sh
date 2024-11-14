#!/bin/bash

export mpp_syslog_perror=1

export PREFERED_VIDEOSINK=xvimagesink
export QT_GSTREAMER_WIDGET_VIDEOSINK=${PREFERED_VIDEOSINK}
export QT_GSTREAMER_WINDOW_VIDEOSINK=${PREFERED_VIDEOSINK}

echo performance | tee $(find /sys/ -name *governor) /dev/null || true

multivideoplayer -platform xcb
