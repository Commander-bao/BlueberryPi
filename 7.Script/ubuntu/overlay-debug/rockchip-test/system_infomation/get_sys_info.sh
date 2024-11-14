#!/bin/bash

DIR_SYSINFO=/rockchip-test/system_infomation

info_view()
{
    echo "*****************************************************"
    echo "***                                               ***"
    echo "***            SYSTEM INFOMATION                  ***"
    echo "***                                               ***"
    echo "*****************************************************"
}

info_view
echo "***********************************************************"
echo "open hardinfo software:						1"
echo "creates a report and print format:				2"
echo "***********************************************************"

read -t 30 SYSINFO_CHOICE

hardinfo_open()
{
	bash ${DIR_SYSINFO}/open_hardinfo.sh
}

report_hardinfo_get()
{
	bash ${DIR_SYSINFO}/get_hardinfo_report.sh
}

case ${SYSINFO_CHOICE} in
	1)
		hardinfo_open
		;;
	2)
		report_hardinfo_get
		;;
	*)
		echo "not fount your input."
		;;
esac
