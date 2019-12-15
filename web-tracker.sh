#!/bin/bash
#ps -o %cpu,pid,ppid,start_time,cmd $(pgrep -P 1 -u yipenghan)
#notify-send "who am i" "I am January"
#tcpdump -i eth0 dst host www.youtube.com or dst www.netflix.com


OLD_C=0
OLD_TIME=$(date +%s.%N)
COUNT=0
TIME_INTERVAL=1
COUNT_INTERVAL=20
LEFT_TIME=$1
TOTAL_TIME=3600
BREAK_TIME=$(echo "$(date +%s.%N) + $TOTAL_TIME" | bc)

  (echo "Zhaoyiting0419" | sudo -S tcpdump -l -i eth0 dst host www.youtube.com or dst www.netflix.com) | while read line; do
    ((COUNT++))
    diff=$((COUNT - OLD_C))
    if (( diff > $COUNT_INTERVAL ));
      then
        time_diff=$(echo "$(date +%s.%N) - $OLD_TIME" | bc)
        if (( $(echo "$time_diff < $TIME_INTERVAL" |bc -l) ));
          then
            notify-send "Web Tracker", "Packet burst from video-streaming website detected"
            echo Packet burst detected
            result=$(source sound_tracker.sh $LEFT_TIME)
            LEFT_TIME=$(echo "$LEFT_TIME - $result" | bc)
            if (( $(echo "$LEFT_TIME < 0" |bc -l) ));
              then
              LEFT_TIME=0
            fi
          fi
        OLD_TIME=$(date +%s.%N)
        OLD_C=$COUNT
    else
      time_diff=$(echo "$(date +%s.%N) - $OLD_TIME" | bc)
      if (( $(echo "$time_diff > $TIME_INTERVAL" |bc -l) ));
        then
          OLD_TIME=$(date +%s.%N)
          OLD_C=$COUNT
        fi
    fi
done
