#!/bin/bash

function test_wifi() {
        ifconfig wlan0 down && ifconfig wlan0 up && ifconfig wlan0 | grep UP
        if [ $? -ne 0 ];then
                echo "The wifi test fail !!!"
                dmesg > /data/wifi_dmesg.txt
                exit 11
        fi
}

function main() {
        while true; do
                test_wifi
                sleep 1
                cnt=$((cnt + 1))
                echo "
        #################################################
        # The WiFi has been tuned on/off for $cnt times #
        #################################################
                "
        done
}

main
