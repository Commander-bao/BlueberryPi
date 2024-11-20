#!/bin/bash -e

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

function run_glmark2() {
if [[ "$1" == "px30" || "$1" == "rk3326" || "$1" == "rk3358" ]]; then
	glmark2-es2 --fullscreen --annotate

elif [[ "$1" == "px3se" || "$1" == "rk3036" || "$1" == "rk312x" ]]; then
	glmark2-es2 --fullscreen --visual-config='stencil=8' --annotate

elif [[ "$1" == "rk1808" || "$1" == "rk3308" ]]; then
	echo "the chips didn't support gpu"

elif [[ "$1" == "rk3288" ]]; then
	glmark2-es2 --fullscreen --annotate

elif [[ "$1" == "rk3328" || "$1" == "rk3528" ]]; then
	glmark2-es2 --fullscreen --visual-config='stencil=8' --annotate

elif [[  "$1" == "rk3399"  ]]; then
	taskset -c 4-5 glmark2-es2 --fullscreen --annotate

elif [[ "$1" == "rk3399pro" ]]; then
	taskset -c 4-5 glmark2-es2 --fullscreen --annotate

elif [[ "$1" == "rk3562" ]]; then
	glmark2-es2 --fullscreen --annotate

elif [[ "$1" == "rk3566" || "$1" == "rk3568" ]]; then
	glmark2-es2 --fullscreen --annotate

elif [[ "$1" == "rk3588" || "$1" == "rk3588s" ]]; then
	taskset -c 4-8 glmark2-es2 --fullscreen --annotate

else
	echo "please check if the linux support it!!!!!!"
fi
}

COMPATIBLE=$(cat -v /proc/device-tree/compatible)

if [[ $(expr $COMPATIBLE : ".*px30") -ne 0 ]]; then
	CHIPNAME="px30"
elif [[ $(expr $COMPATIBLE : ".*px3se") -ne 0 ]]; then
	CHIPNAME="px3se"
elif [[ $(expr $COMPATIBLE : ".*rk1808") -ne 0 ]]; then
	CHIPNAME="rk1808"
elif [[ $(expr $COMPATIBLE : ".*rk3036") -ne 0 ]]; then
	CHIPNAME="rk3036"
elif [[ $(expr $COMPATIBLE : ".*rk3126") -ne 0 ]]; then
	CHIPNAME="rk312x"
elif [[ $(expr $COMPATIBLE : ".*rk3128") -ne 0 ]]; then
	CHIPNAME="rk312x"
elif [[ $(expr $COMPATIBLE : ".*rk3288") -ne 0 ]]; then
	CHIPNAME="rk3288"
elif [[ $(expr $COMPATIBLE : ".*rk3308") -ne 0 ]]; then
	CHIPNAME="rk3308"
elif [[ $(expr $COMPATIBLE : ".*rk3326") -ne 0 ]]; then
	CHIPNAME="rk3326"
elif [[ $(expr $COMPATIBLE : ".*rk3328") -ne 0 ]]; then
	CHIPNAME="rk3328"
elif [[ $(expr $COMPATIBLE : ".*rk3358") -ne 0 ]]; then
	CHIPNAME="rk3358"
elif [[ $(expr $COMPATIBLE : ".*rk3399") -ne 0 ]]; then
	CHIPNAME="rk3399"
elif [[ $(expr $COMPATIBLE : ".*rk3399pro") -ne 0 ]]; then
	CHIPNAME="rk3399pro"
elif [[ $(expr $COMPATIBLE : ".*rk3528") -ne 0 ]]; then
	CHIPNAME="rk3528"
elif [[ $(expr $COMPATIBLE : ".*rk3562") -ne 0 ]]; then
	CHIPNAME="rk3562"
elif [[ $(expr $COMPATIBLE : ".*rk3566") -ne 0 ]]; then
	CHIPNAME="rk3566"
elif [[ $(expr $COMPATIBLE : ".*rk3568") -ne 0 ]]; then
	CHIPNAME="rk3568"
elif [[ $(expr $COMPATIBLE : ".*rk3588") -ne 0 ]]; then
	CHIPNAME="rk3588"
else
	CHIPNAME="rk3399"
fi

COMPATIBLE=${COMPATIBLE#rockchip,}

echo performance | tee $(find /sys/ -name *governor) > /dev/null 2>&1 || true

echo "run glmark2 x11 with fullscreen......"

run_glmark2 ${CHIPNAME}

echo "the governor is performance for now, please restart it......"
