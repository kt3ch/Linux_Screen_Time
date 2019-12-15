#!/bin/bash


FOCUS_TIME=60
BREAK_TIME=3000

while true; do
  next_break=$(echo "$(date +%s.%N) + $FOCUS_TIME" | bc)
  notify-send "Scheduler", "Next break is scheduled in 2 hours. Get to work!"
  sleep 10
  /home/yipenghan/Documents/cs296-41-sp19/web-tracker.sh 0 &
  tracker_pid=$!
  sleep $FOCUS_TIME
  echo "Zhaoyiting0419" | sudo -S kill -9 $tracker_pid
  sleep 5
  notify-send "Scheduler", "You can take a break for 30 mins now!"
  /home/yipenghan/Documents/cs296-41-sp19/web-tracker.sh $BREAK_TIME &
  tracker_pid=$!
  sleep $BREAK_TIME
  #echo "Zhaoyiting0419" | sudo -S kill -9 $tracker_pid
  break
done
