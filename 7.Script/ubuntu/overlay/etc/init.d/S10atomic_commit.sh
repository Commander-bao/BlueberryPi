#!/bin/bash -e
### BEGIN INIT INFO
# Provides:          S10atomic_commit
# Required-Start:
# Required-Stop:
# Default-Start:
# Default-Stop:
# Short-Description:
# Description:       Setup enable async for display
### END INIT INFO
#
# For new rockchip BSP kernel only.
# Enable ASYNC_COMMIT by default to keep the same behavior as the old
# BSP 4.4 kernel.
#

which modetest || exit 0

case "$1" in
	start)
		for p in $(modetest|grep "^Planes:" -A 9999|grep -o "^[0-9]*");
		do
			modetest -M rockchip -aw $p:ASYNC_COMMIT:1 &>/dev/null
		done
		;;
	stop)
		;;
	restart|reload)
		;;
	*)
		echo "Usage: $0 {start|stop|restart}"
		exit 1
esac

exit $?
