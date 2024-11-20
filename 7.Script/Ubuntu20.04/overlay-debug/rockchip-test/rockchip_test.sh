#!/bin/bash
### file: rockchip-test.sh
### function: ddr cpu gpio flash bt audio recovery s2r sdio/pcie(wifi)
###           ethernet reboot ddrfreq npu camera video and so on.

CURRENT_DIR=`dirname $0`

moudle_env()
{
	export MODULE_CHOICE
}

module_choice()
{
    echo "******************************************************"
    echo "***                                                ***"
    echo "***          *****************************         ***"
    echo "***          *    ROCKCHIPS TEST TOOLS   *         ***"
    echo "***          *  V2.2 updated on 20231214 *         ***"
    echo "***          *****************************         ***"
    echo "***                                                ***"
    echo "*****************************************************"


    echo "*****************************************************"
    echo "ddr test:              1 (ddr stress test)"
    echo "cpu test:              2 (cpu stress test)"
    echo "gpu test:              3 (gpu stress test)"
    echo "npu test:              4 (npu stress test)"
    echo "suspend_resume test:   5 (suspend resume)"
    echo "reboot test:           6 (auto reboot test)"
    echo "power lost test:       7 (power lost test)"
    echo "flash stress test:     8 (flash stress test)"
    echo "recovery test:         9 (recovery wipe all test)"
    echo "audio test:           10 (audio test)"
    echo "camera test:          11 (camera test)"
    echo "video test:           12 (video test)"
    echo "bluetooth test:       13 (bluetooth test)"
    echo "wifi test:            14 (wifi test)"
    echo "wifibt config test:   15 (wifibt config test)"
    echo "chromium test:        16 (chromium with video test)"
    echo "*****************************************************"

    read -t 30 -p "please input test moudle: " MODULE_CHOICE
}

npu_stress_test()
{
    bash ${CURRENT_DIR}/npu/npu_test.sh
}

npu2_stress_test()
{
    bash ${CURRENT_DIR}/npu2/npu_test.sh
}

ddr_test()
{
    bash ${CURRENT_DIR}/ddr/ddr_test.sh
}

cpu_test()
{
    bash ${CURRENT_DIR}/cpu/cpu_test.sh
}

flash_stress_test()
{
    bash ${CURRENT_DIR}/flash_test/flash_stress_test.sh 5 20000 &
}

recovery_test()
{
    bash ${CURRENT_DIR}/recovery/recovery_test.sh
}

suspend_resume_test()
{
    bash ${CURRENT_DIR}/suspend_resume/suspend_resume.sh
}

wifi_test()
{
    bin=/usr/bin/rkwifibt_app_test;
    if [ -e "$bin" ]; then
        $bin WiFi
    else
        echo "WiFiBT testfile don't exist! fallback to wifi_onff.sh"
        bash ${CURRENT_DIR}/wifibt/wifi_onoff.sh &
    fi
}

bluetooth_test()
{
    bin=/usr/bin/rkwifibt_app_test;
    if [ -e "$bin" ]; then
        $bin BT
    else
        echo "WiFiBT testfile don't exist! fallback to bt_onoff.sh"
        bash ${CURRENT_DIR}/wifibt/bt_onoff.sh &
    fi
}

wifibt_config_test()
{
    bin=/usr/bin/rkwifibt_app_test;
    if [ -e "$bin" ]; then
        $bin Network
    else
        echo "WiFiBT testfile don't exist! "
    fi
}

audio_test()
{
    bash ${CURRENT_DIR}/audio/audio_functions_test.sh
}

auto_reboot_test()
{
    fcnt=/userdata/rockchip/reboot_cnt;
    if [ -e "$fcnt" ]; then
	rm -f $fcnt;
    fi
    bash ${CURRENT_DIR}/auto_reboot/auto_reboot.sh
}

camera_test()
{
    bash ${CURRENT_DIR}/camera/camera_test.sh
}

video_test()
{
    bash ${CURRENT_DIR}/video/video_test.sh
}

gpu_test()
{
    bash ${CURRENT_DIR}/gpu/gpu_test.sh
}

chromium_test()
{
    bash ${CURRENT_DIR}/chromium/chromium_test.sh
}

power_lost_test()
{
    fcnt=/userdata${CURRENT_DIR}/power_lost/reboot_cnt;
    if [ -e "$fcnt" ]; then
        rm -f $fcnt;
    fi
    bash ${CURRENT_DIR}/flash_test/power_lost_test.sh  &
}

module_test()
{
	case ${MODULE_CHOICE} in
		1)
			ddr_test
			;;
		2)
			cpu_test
			;;
		3)
			gpu_test
			;;
		4)
			npu2_stress_test
			;;
		5)
			suspend_resume_test
			;;
		6)
			auto_reboot_test
			;;
		7)
			power_lost_test
			;;
		8)
			flash_stress_test
			;;
		9)
			recovery_test
			;;
		10)
			audio_test
			;;
		11)
			camera_test
			;;
		12)
			video_test
			;;
		13)
			bluetooth_test
			;;
		14)
			wifi_test
			;;
		15)
			wifibt_config_test
			;;
		16)
			chromium_test
			;;
	esac
}

module_choice
module_test
