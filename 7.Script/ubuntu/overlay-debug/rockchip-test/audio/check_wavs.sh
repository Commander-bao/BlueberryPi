#!/bin/bash

WAVS_PATH=$1
ERR_CNT=0

PREFIX_LOG="/tmp/check_logs"
TMP_STAT_LOG="tmp_stat.log"
TMP_STATS_LOG="tmp_stats.log"
STAT_LOG="stat.log"
STATS_LOG="stats.log"
RESULT_LOG="result.log"

echo "WAVS_PATH: $WAVS_PATH"

check_prepare()
{
	if [ -n "$PREFIX_LOG" ]; then
		TMP_STAT_LOG="$PREFIX_LOG/$TMP_STAT_LOG"
		TMP_STATS_LOG="$PREFIX_LOG/$TMP_STATS_LOG"
		STAT_LOG="$PREFIX_LOG/$STAT_LOG"
		STATS_LOG="$PREFIX_LOG/$STATS_LOG"
		RESULT_LOG="$PREFIX_LOG/$RESULT_LOG"

		mkdir -p $PREFIX_LOG
	else
		echo "PREFIX_LOG is empty"
	fi

	rm $TMP_STAT_LOG -f
	rm $TMP_STATS_LOG -f
	rm $STAT_LOG -f
	rm $STATS_LOG -f

	echo "there is no error on test loopback" > $RESULT_LOG
}

# There is don't need to add function keyword on busybox shell
check_wav()
{
	wav=$1
	threshold_db=-15

	echo "will check wav: $wav with threshold_db: $threshold_db"

	sox $wav -n stat 2> $TMP_STAT_LOG
	sox $wav -n stats 2> $TMP_STATS_LOG

	echo "======== $wav stat info: ========" >> $STAT_LOG
	cat $TMP_STAT_LOG >> $STAT_LOG
	echo >> $STAT_LOG

	echo "======== $wav stats info: ========" >> $STATS_LOG
	cat $TMP_STATS_LOG >> $STATS_LOG
	echo >> $STATS_LOG

	l_pk=`awk 'NR==5{ printf "%.2f", $5 }' $TMP_STATS_LOG`
	r_pk=`awk 'NR==5{ printf "%.2f", $6 }' $TMP_STATS_LOG`
	echo "l_pk: $l_pk, r_pk: $r_pk"

	last_err=$ERR_CNT
	ERR_CNT=$(echo $l_pk $threshold_db $ERR_CNT | awk '{
		if ($1 > $2) {
			$3+=1;
		}
	} END {
		printf "%d", $3;
	}')

	if [ $last_err != $ERR_CNT ]; then
		echo "ERROR! $wav Left Pk lev dB: $l_pk > $threshold_db" >> $RESULT_LOG
	else
		echo "OK! $wav Left Pk lev dB: $l_pk < $threshold_db" >> $RESULT_LOG
	fi

	last_err=$ERR_CNT
	ERR_CNT=$(echo $r_pk $threshold_db $ERR_CNT | awk '{
		if ($1 > $2) {
			$3+=1;
		}
	} END {
		printf "%d", $3;
	}')

	if [ $last_err != $ERR_CNT ]; then
		echo "ERROR! $wav Right Pk lev dB: $r_pk > $threshold_db" >> $RESULT_LOG
	else
		echo "OK! $wav Right Pk lev dB: $r_pk < $threshold_db" >> $RESULT_LOG
	fi

	echo "total ERR_CNT: $ERR_CNT"

	#cat $TMP_STATS_LOG | while read line
	#do
		# echo "line: $line"
	#	label=`echo $line | awk '{ print $1 }'`
	#	echo "label: $label"
	#done
}

check_start()
{
	cd $WAVS_PATH

	check_prepare

	for file in `ls $WAVS_PATH`
	do
		if [ -f $file ]; then
			# echo "found file: $file"

			suffix=$(echo "$file" | cut -d . -f2)
			# echo "found suffix: $suffix"

			if [ $suffix == "wav" ]; then
				# echo "found wav file: $file"
				check_wav $file
			fi
		fi
	done
}

check_start
