#!/bin/bash

down=$(ifconfig eth0 | head -n +5 | tail -n +5);
up=$(ifconfig eth0 | head -n +7 | tail -n +7);
format_arr=($down)
old_down=${format_arr[4]}
format_arr=($up)
old_up=${format_arr[4]}
while true; do
    start=$(date +%s.%N)
    down=$(ifconfig eth0 | head -n +5 | tail -n +5);
    up=$(ifconfig eth0 | head -n +7 | tail -n +7);
    format_arr=($down)
    new_down=${format_arr[4]}
    format_arr=($up)
    new_up=${format_arr[4]}
    diff_down_Mb=$(((new_down - old_down)/65536))
    diff_down_Kb=$(((new_down - old_down)/64))
    diff_down_b=$(((new_down - old_down)*16))
    diff_up_Mb=$(((new_up - old_up)/65536))
    diff_up_Kb=$(((new_up - old_up)/64))
    diff_up_b=$(((new_up - old_up)/16))
    diff_down=0
    unit_down=""
    diff_up=0
    unit_up=""
    if [ $diff_down_Mb -eq 0 ];
    then
      if [ $diff_down_Kb -eq 0 ];
        then
          diff_down=$diff_down_b
          unit_down="bps"
        else
          diff_down=$diff_down_Kb
          unit_down="Kbps"
        fi
    else
      diff_down=$diff_down_Mb
      unit_down="Mbps"
    fi

    if [ $diff_up_Mb -eq 0 ];
    then
      if [ $diff_up_Kb -eq 0 ];
        then
          diff_up=$diff_up_b
          unit_up="bps"
        else
          diff_up=$diff_up_Kb
          unit_up="Kbps"
        fi
    else
      diff_up=$diff_up_Mb
      unit_up="Mbps"
    fi
    printf "Download:%4s %-4s Upload:%4s %-4s\r" $diff_down $unit_down $diff_up $unit_up

    old_down=$new_down
    old_up=$new_up
    dur=$(echo "0.5 - $(date +%s.%N) + $start" | bc)
    sleep $dur
done
