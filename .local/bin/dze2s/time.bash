#!/bin/bash

# Source settings file
. $(dirname $0)/settings.bash

# Source dzen command
. $(dirname $0)/command.bash

while :; do

  echo " ^fg($MAGENTA) \
^fg($FG) | \
^fg($BLUE) $(date +%H:%M)   "

  sleep $SLEEP
done | $DZEN
