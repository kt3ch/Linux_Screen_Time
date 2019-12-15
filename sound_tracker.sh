#!/bin/bash

DIR='/proc/asound/AudioPCI/pcm0p/sub0/status'
TRACKING=0
DURATION=0
LIMIT_TIME=$(echo "$(date +%s.%N) + $1" | bc)
LIMITED=0
sleep 2
while true; do
  line=$(cat $DIR)
  if [ "$line" = "closed" ];
  then
    if [ $TRACKING -eq 0 ]; then
        #notify-send "Sound Tracker", "Error, the sound card is closed."
        echo 0
        break
    else
        TRACKING=0
        DURATION=$((DURATION - 4))
        hours=$((DURATION / 3600))
        mins=$(((DURATION % 3600) / 60))
        secs=$((DURATION % 60))
        notify-send "Sound Tracker", "$hours hours $mins mins $secs secs of audio have been played during passed session."
        ./bandwidth.sh end
        LIMITED=1
        echo "$DURATION"
        break
    fi
  else
    TRACKING=1
    start=$(cat $DIR | head -n +3 | tail -n +3)
    end=$(cat $DIR | head -n +4 | tail -n +4)
    format_arr=($start)
    trigger_time=${format_arr[1]}
    format_arr=($end)
    tstamp=${format_arr[2]}
    DURATION=$(echo "$tstamp - $trigger_time" | bc)
    DURATION=${DURATION%.*}
    #echo "duration is $DURATION, MAX time is $1"
    if (( $(echo "$DURATION > $1" |bc -l) ));
      then
        # handle streaming service
        notify-send "Sound tracker", "It's not break time, go to work."
        if (( $(echo "$LIMITED == 0" |bc -l) ));
          then
            ./bandwidth.sh start
            LIMITED=1
        fi
        DURATION=$DURATION
    fi
    #echo "$DURATION"
    sleep 1
  fi
done
