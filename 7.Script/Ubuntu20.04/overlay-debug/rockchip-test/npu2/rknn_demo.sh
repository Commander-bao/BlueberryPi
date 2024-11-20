#!/bin/bash

COMPATIBLE=$(cat /proc/device-tree/compatible)
if [[ $(expr $COMPATIBLE : ".*rk3588") -ne 0 ]]; then
	rknn_common_test /usr/share/model/RK3588/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
elif [[ $(expr $COMPATIBLE : ".*rk3568") -ne 0 ]]; then
	rknn_common_test /usr/share/model/RK3566_RK3568/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
elif [[ $(expr $COMPATIBLE : ".*rk3566") -ne 0 ]]; then
	rknn_common_test /usr/share/model/RK3566_RK3568/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
elif [[ $(expr $COMPATIBLE : ".*rk3562") -ne 0 ]]; then
	rknn_common_test /usr/share/model/RK3562/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
else
	echo "The RKNPU2 did't support this Socs yet..."
fi
