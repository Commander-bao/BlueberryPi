#!/bin/bash
#/******************************************************************/
#/*  Copyright (C)  ROCK-CHIPS . All Rights Reserved.       */
#/*******************************************************************
#File    :   flash_stress_test.sh
#Desc    :   flash write and read stress test tools
#Author  :   ZYF
#Date    :   2020-07-16
#Notes   :    
# Revision Data       Author                                Note.
# 1.00     2017/05/05 Zhaoyifeng                            1.First version
# 1.10     2020/06/28 Dingqiang Lin(jon.lin@rock-chips.com) 1.Simplify test_log 2.Add more introduction
# 1.20     2020/07/16 Hans Yang                             1.use /dev/urandom to generate test data
#Introduction.
#********************************************************************/
# usage£º
# sudo flash_stress_test.sh dirnum testcount
# example  £º
# 	count for script command:
#		SLC Nand 128MB, 100K P/E cycles, normaly we test 5K P/E ¡ª¡ª 128MB * 5000
#       src file size 5MB, totle test data 128MB * 5000, testcount = 128MB * 5000 / 5MB * 5(dirnum) = 20600
#   command:
#		sudo flash_stress_test.sh 5 20000
#	available space need:
#		src file size: 5MB
#		des file size: 5MB * dirnum = 25MB
#       log file size: 189B(log item size) * 20000 = 3691KB
#			    total: about 34MB
#   result analyze:
#		success:
#			1. shell progress stop;
#			2. print "-------copy and check success------------"
#		fail:
#			1. shell progress stop;
#			2. any printing with "error" tag
#
#********************************************************************/

test_dir=/data/rockchip-test/flash_test
source_dir=$test_dir/src_test_data
dest_dir=$test_dir/des_test_data
md5_dir=$test_dir/md5_data

usage()
{
echo "Usage: flash_stress_test.sh [dirnum] [looptime]"
echo "flash_stress_test.sh 5 20000"
}

test_max_count=200
test_max_dir=5
if [ $1 -ne 0 ] ;then
    test_max_dir=$1
fi

if [ $2 -ne 0 ] ;then
    test_max_count=$2
fi

echo "Test Max dir Num = ${test_max_dir}"
echo "Test Max count = ${test_max_count}"

count=0
dir_loop=0
rm -rf  $test_dir/test_log.txt
mkdir -p $dest_dir
mkdir -p $md5_dir
mkdir -p $source_dir

#generate 5MB random file 
rm -rf  $source_dir/*
file_path=$source_dir
file_size=(512 1024 3456 512 1024 3456)  
file_radio=(5 5 5 5 5 5)  
  
function random()  
{  
    min=$1  
    max=$2  
    num=`date +%s`  
    ((value=$num%($max-$min)+$min+1))  
    echo $value  
}  
  
file_size_count=${#file_size[*]}  
file_radio_count=${#file_radio[*]}  
  
if [ $file_size_count=$file_radio_count  ]   
then   
    for ((i=0;i <$file_size_count;i++))  
    do  
        for  ((n=0;n <${file_radio[$i]};n++))  
        do  
            if [ $i==0 ]  
            then  
                rand=$(random 0 ${file_size[$i]})  
            else  
                rand=$(random ${file_size[$i-1]} ${file_size[$i]})  
            fi  
            dd if=/dev/urandom of=$file_path/test.$i.$rand.bin bs=$rand count=1024
        done  
        echo ===========  
    done  
fi  

cd $source_dir

#find ./ -type f -print0 | xargs -0 md5sum | sort > $md5_dir/source.md5
md5sum ./* > $md5_dir/source.md5
cd /
while [ $count -lt $test_max_count ]; do
	echo $count
	echo $count >> $test_dir/test_log.txt
    dir_loop=0
    while [ $dir_loop -lt $test_max_dir ]; do
	echo "$count test $source_dir to $dest_dir/${dir_loop}"
    	rm -rf  $dest_dir/$dir_loop
    	if [ $? == 0 ]; then
    		echo "$count clean $dest_dir/${dir_loop} success"
		echo "$count clean ${dir_loop}" >> $test_dir/test_log.txt
    	else
    		echo "$count clean $dest_dir/${dir_loop} error"
    		echo "$count clean $dest_dir/${dir_loop} error" >> $test_dir/test_log.txt
    		exit 0
    	fi
    	#sync
    	#sleep 1
    	#start copy data
    	echo "$count $dir_loop start copy data"
    	cp  -rf   $source_dir $dest_dir/$dir_loop
    	if [ $? == 0 ]; then
    		echo "$count cp  $source_dir to $dest_dir/${dir_loop} success"
		echo "$count cp ${dir_loop}" >> $test_dir/test_log.txt
    	else
    		echo "$count cp  $source_dir to $dest_dir/${dir_loop} error"
    		echo "$count cp  $source_dir to $dest_dir/${dir_loop} error" >> $test_dir/test_log.txt
    	fi
    	#sync
    	#sleep 1
    	dir_loop=$(($dir_loop+1))
    done
    dir_loop=0
    sync && echo 3 > /proc/sys/vm/drop_caches
    sleep 5
    sync
    echo 3 > /proc/sys/vm/drop_caches
    sleep 5
    while [ $dir_loop -lt $test_max_dir ]; do
	#calc dir md5
    	echo "$count calc $dest_dir/${dir_loop} md5 start"
    	echo "$count calc $dest_dir/${dir_loop} md5 start" >> $test_dir/test_log.txt
    	cd $dest_dir/${dir_loop}
    	#find ./ -type f -print0 | xargs -0 md5sum | sort > $md5_dir/dest${dir_loop}.md5
    	md5sum ./* > $md5_dir/dest${dir_loop}.md5
    	cd /
    	#cmp with src md5
    	diff $md5_dir/source.md5 $md5_dir/dest${dir_loop}.md5
    	if [ $? == 0 ]; then
    		echo "$count check source to $dest_dir/${dir_loop} success"
		echo "$count check ${dir_loop}" >> $test_dir/test_log.txt
    		rm  $md5_dir/dest${dir_loop}.md5
			rm -rf  $dest_dir/$dir_loop
    	else
    		echo "$count check source to $dest_dir/${dir_loop} error"
    		echo "$count check source to $dest_dir/${dir_loop} error" >> $test_dir/test_log.txt
    		exit 0
    	fi
    	dir_loop=$(($dir_loop+1))
    done
	count=$(($count+1))
        #if test fail, we can save file for debug
	#rm -rf  $test_dir/$dest_dir/*
	echo -----------------------------------------
	echo "-------========You can see the result at and $test_dir/test_log.txt file=======------------"
	echo -----------------------------------------  >> $test_dir/test_log.txt
done

	echo "-------copy and check success------------"
	echo "-------copy and check success------------"  >> $test_dir/test_log.txt
	echo "-------========You can see the result at and $test_dir/test_log.txt file=======------------"





