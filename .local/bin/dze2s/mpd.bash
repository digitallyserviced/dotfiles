#!/bin/bash

# Source settings file
. $(dirname $0)/settings.bash

# Source dzen command
. $(dirname $0)/command.bash

# Modify Settings
Y=$((Y+35))

while :; do

  echo " ^fg($GREEN)^ca(1,mpc toggle)^ca(3,urxvt -geometry -50+50 -e ncmpcpp)^ca(4,mpc next)^ca(5,mpc prev) \
$(mpc -f %artist% current | tr '[:lower:]' '[:upper:]') \
^fg($FG) | \
^fg($YELLOW) \
$(mpc -f %title% current | tr '[:lower:]' '[:upper:]')^ca()^ca()^ca()^ca() \
^fg($FG) | \
^fg($RED)^ca(4,amixer set Master 5%+)^ca(5,amixer set Master 5%-) \
$(amixer sget Master | grep -m1 "%]" | cut -d "[" -f2 | cut -d "]" -f1)   ^ca()^ca()"

  sleep $SLEEP
done | $DZEN
