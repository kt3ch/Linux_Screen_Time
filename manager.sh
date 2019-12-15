#!/bin/bash
declare -a process_list
LIMIT=60      # cpu threshold
GAP=1
COUNT=0
TIME=10       # time threshold
MAXUSAGE=25   # max cpu usage after limited in %
MAXMEM=104857601  # limiting maximum memory usage to 100MB
CORE=$(grep -c ^processor /proc/cpuinfo)                      # get cores# so this program can properly working on computer with any number of cores
PERIOD=$(cat /sys/fs/cgroup/cpu/cpu.cfs_period_us)
TARGET_PROCESS=""
cgcreate -g cpu,memory:g1                                            # a temporarily solution for not having cgconfi service up and running
echo "Programming running on a $CORE core(s) computer with default cfs_period_us set to $PERIOD"
echo "Configuring cgroup"
echo $PERIOD > /sys/fs/cgroup/cpu/g1/cpu.cfs_period_us         # set the period of our limited resources cgroup
QUOTA=$((PERIOD / CORE * MAXUSAGE / 100))
echo $QUOTA > /sys/fs/cgroup/cpu/g1/cpu.cfs_quota_us
echo $MAXMEM > /sys/fs/cgroup/memory/g1/memory.limit_in_bytes
echo 1 > /sys/fs/cgroup/memory/g1/memory.oom_control
echo "Configuration finished. Start monitoring process."
while true; do

  #ps -U 1000 -o %cpu,rss,pid,start_time,cmd --sort -%cpu -t | head -n +2 | tail -n +2 | while read line; do
  #while read line; do
  line=$(ps -U 1000 -o %cpu,rss,pid,start_time,cmd --sort -%cpu -t | head -n +2 | tail -n +2);
    format_arr=($line)
    HIGHEST=${format_arr[0]}

    if [ $(echo "$HIGHEST > $LIMIT" | bc) -ne 0 ];
    then
      ((COUNT++))
      echo "Warning, CPU usage of process ${format_arr[4]} has exceeded limit for $COUNT seconds."  # cpu
      echo  "Process ID: ${format_arr[2]} CPU usage: ${format_arr[0]}"
      TARGET_PROCESS=${format_arr[4]}
      #echo ${format_arr[2]}   # pid
      #echo ${format_arr[4]}   # cmd
      GAP=1
      if [ $COUNT -ge $TIME ];
      then
        let COUNT=0         # reset COUNT
        echo "CPU usage of process $TARGET_PROCESS exceed limit for $TIME sec. Limiting CPU usage."
        echo ${format_arr[2]} >> /sys/fs/cgroup/cpu/g1/cgroup.procs
        echo ${format_arr[2]} >> /sys/fs/cgroup/memory/g1/cgroup.procs
        sleep 5
      fi

    else
      if [ $COUNT -gt 0 ];
      then
        echo "CPU usage of process $TARGET_PROCESS has dropped below limit. Timer reset."
      fi
      let GAP=1
      let COUNT=0
    fi
    sleep $GAP
  #done <<<$(ps -U 1000 -o %cpu,rss,pid,start_time,cmd --sort -%cpu -t | head -n +2 | tail -n +2)

done
