#!/bin/bash

COMPATIBLE=$(cat /proc/device-tree/compatible)

while true
do
if [[ $COMPATIBLE =~ "rk3588" ]]; then
    rknn_common_test /usr/share/model/RK3588/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
elif [[ $COMPATIBLE =~ "rk3566" ]]; then
    rknn_common_test /usr/share/model/RK3566_RK3568/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
elif [[ $COMPATIBLE =~ "rk3568" ]]; then
    rknn_common_test /usr/share/model/RK3566_RK3568/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
elif [[ $COMPATIBLE =~ "rk3562" ]]; then
    rknn_common_test /usr/share/model/RK3562/mobilenet_v1.rknn /usr/share/model/dog_224x224.jpg 10
else
   echo "please check if the linux support it!!!!!!!"
fi
done
