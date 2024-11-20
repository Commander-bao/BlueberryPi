#!/bin/bash

COMPATIBLE=$(cat /proc/device-tree/compatible)

if [ -e "/sys/devices/platform/f8000000.pcie/pcie_reset_ep" ] ;
then
    echo "upgrading npu with pcie image......\n"

    if [[ $COMPATIBLE =~ "rk3399pro-evb-v14-linux" ]];
    then
        cd /usr/share/npu_fw_pcie/
        npu_upgrade_pcie_combine MiniLoaderAll.bin uboot.img trust.img boot.img
        cd /usr/bin/
        mv npu_powerctrl_combine npu_powerctrl
    else
        cd /usr/share/npu_fw_pcie/
        npu_upgrade_pcie MiniLoaderAll.bin uboot.img trust.img boot.img
    fi
else
    echo "upgrading npu with usb image......\n"
    cd /usr/share/npu_fw/
    npu_upgrade MiniLoaderAll.bin uboot.img trust.img boot.img
fi

sleep 1

echo "update npu image ok\n"
