#!/bin/bash

MONITOR="eDP-1"
MODE="preferred"
POSITION="auto"
SCALE="1"

# File to store rotation toggle state (0 = off, 1 = on)
TOGGLE_FILE="$HOME/.config/hypr/rotation-toggle"

# Ensure toggle file exists, default to enabled (1)
[ -f "$TOGGLE_FILE" ] || echo "1" > "$TOGGLE_FILE"

monitor-sensor | while read -r line; do
	toggle_file_cont=$(<$TOGGLE_FILE)
  if [[ $toggle_file_cont -eq "1" ]]; then
	echo "enabled"
  if [[ $line == *"orientation changed: normal"* ]]; then
   TRANSFORM=0
  elif [[ $line == *"orientation changed: right-up"* ]]; then
    TRANSFORM=3
  elif [[ $line == *"orientation changed: left-up"* ]]; then
    TRANSFORM=1
  elif [[ $line == *"orientation changed: bottom-up"* ]]; then
    TRANSFORM=2
  else
    continue
  fi

  hyprctl eval 'hl.monitor ({ output="'$MONITOR'",mode= "'$MODE'",position="'$POSITION'",transform= '$TRANSFORM'})'
  hyprctl eval 'hl.device ({name="elan901c:00-04f3:2a41",  transform=' $TRANSFORM'})'
 #echo $MONITOR
 #echo $MODE
 #echo $POSITION
 #echo $TRANSFORM
else
	echo "disabled"
  fi

done
