#!/bin/bash

case "$1" in
	start)
		if [ -e "/data/rockchip-test/auto_reboot.sh" ]; then
			echo "start recovery auto-reboot"
			mkdir -p /data/rockchip-test
			cp /rockchip-test/auto_reboot/auto_reboot.sh /data/rockchip-test/
		fi

		if [ -e "/data/rockchip-test/power_lost_test.sh" ]; then
			echo "start test flash power lost"
			source /data/rockchip-test/power_lost_test.sh &
		fi
		if [ -e "/data/rockchip-test/auto_reboot.sh" ]; then
			echo "start auto-reboot"
			source /data/rockchip-test/auto_reboot.sh `cat /data/rockchip-test/reboot_total_cnt`&
		fi

		;;
	stop)
		echo "stop auto-reboot finished"
		;;
	restart|reload)
		$0 stop
		$0 start
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac

exit 0
