#!/bin/bash -e

PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
board_info() {
    if [[ "$2" == "rk3566" ||  "$2" == "rk3568" ]]; then
        case $1 in
            *)
                BOARD_NAME='BlueberryPi-RK356X'
                BOARD_DTB='BlueberryPi.dtb'
                BOARD_uEnv='uEnvLubanCat.txt'
                ;;
        esac
    fi

    echo "BOARD_NAME:"$BOARD_NAME
    echo "BOARD_DTB:"$BOARD_DTB
    echo "BOARD_uEnv:"$BOARD_uEnv
}

# voltage_scale
# 1.7578125 1.8v/10bit
# 3.222656250 3.3v/10bit
# 0.439453125 1.8v/12bit
# 0.8056640625 3.3v/12bit
get_index(){

    ADC_RAW=$(cat /sys/bus/iio/devices/iio\:device0/in_voltage${1}_raw)
    echo ADC_CH:$1 ADC_RAW:$ADC_RAW
    INDEX=0xff

    if [ $(echo "$ADC_voltage_scale > 1 "|bc) -eq 1 ] ; then
        declare -a ADC_INDEX=(229 344 460 595 732 858 975 1024)
    else
        declare -a ADC_INDEX=(916 1376 1840 2380 2928 3432 3900 4096)
    fi

    for i in 00 01 02 03 04 05 06 07; do
        if [ $ADC_RAW -lt ${ADC_INDEX[$i]} ]; then
            INDEX=$i
            break
        fi
    done
}

board_id() {
    ADC_voltage_scale=$(cat /sys/bus/iio/devices/iio\:device0/in_voltage_scale)
    echo "ADC_voltage_scale:"$ADC_voltage_scale

    SOC_type=$(cat /proc/device-tree/compatible | cut -d,  -f 3 | sed 's/\x0//g')
    echo "SOC_type:"$SOC_type

    if [[ "$SOC_type" == "rk3128" ]]; then
        get_index 0
        ADC_INDEX_H=$INDEX

        get_index 2
        ADC_INDEX_L=$INDEX
    else
        get_index 2
        ADC_INDEX_H=$INDEX

        get_index 3
        ADC_INDEX_L=$INDEX
    fi

    BOARD_ID=$ADC_INDEX_H$ADC_INDEX_L
    echo "BOARD_ID:"$BOARD_ID
}

board_id
board_info ${BOARD_ID} ${SOC_type}

# first boot configure

until [ -e "/dev/disk/by-partlabel/boot" ]
do
    echo "wait /dev/disk/by-partlabel/boot"
    sleep 0.1
done

if [ ! -e "/boot/boot_init" ] ; then
    if [ ! -e "/dev/disk/by-partlabel/userdata" ] ; then
        if [ ! -L "/boot/rk-kernel.dtb" ] ; then
            for x in $(cat /proc/cmdline); do
                case $x in
                root=*)
                    Root_Part=${x#root=}
                    ;;
                boot_part=*)
                    Boot_Part_Num=${x#boot_part=}
                    ;;
                esac
            done

            Boot_Part="${Root_Part::-1}${Boot_Part_Num}"
            mount "$Boot_Part" /boot
            echo "$Boot_Part  /boot  auto  defaults  0 2" >> /etc/fstab
        fi

        service lightdm stop || echo "skip error"

        apt install -fy --allow-downgrades /boot/kerneldeb/* || true
        apt-mark hold linux-headers-$(uname -r) linux-image-$(uname -r) || true

        ln -sf dtb/$BOARD_DTB /boot/rk-kernel.dtb
        ln -sf $BOARD_uEnv /boot/uEnv/uEnv.txt

        touch /boot/boot_init
        rm -f /boot/kerneldeb/*
        cp -f /boot/logo_kernel.bmp /boot/logo.bmp
        reboot
    else
        echo "PARTLABEL=oem  /oem  ext2  defaults  0 2" >> /etc/fstab
        echo "PARTLABEL=userdata  /userdata  ext2  defaults  0 2" >> /etc/fstab
        touch /boot/boot_init
    fi
fi
