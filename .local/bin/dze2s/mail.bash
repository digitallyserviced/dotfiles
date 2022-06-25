#!/bin/bash

# Source settings file
. $(dirname $0)/settings.bash

# Source dzen command
. $(dirname $0)/command.bash

# Modify settings
Y=$((Y+70))

# Get mailcount Gmail
gmail() {
  count=0
  if [[ ! -n `ls ${MAILDIR}` ]]; then
    echo -n "0"
  else
    count=`ls -1 ${MAILDIR} | wc -l`
    echo -n "${count}"
  fi
}

# Get mailcount mail.com
cmail() {
  count=0
  if [[ ! -n `ls ${MAILDIR2}` ]]; then
    echo -n "0"
  else
    count=`ls -1 ${MAILDIR2} | wc -l`
    echo -n "${count}"
  fi
}

# Get pacman packages
pacman() {
  echo -n $(grep core ~/.cache/pacmanupdates | wc -l)
  echo -n "/"
  echo -n $(grep extra ~/.cache/pacmanupdates | wc -l)
  echo -n "/"
  echo -n $(grep community ~/.cache/pacmanupdates | wc -l)
}

while :; do

  echo " ^fg($RED) ^ca(1,urxvt -geometry 110x30-50+50 -e mutt)\
MAIL: $(gmail)/$(cmail) ^ca()\
^fg($FG) | ^ca(1,urxvt -geometry -50+50 -e sudo packer -Syu)\
^fg($CYAN) PAC: $(pacman)   ^ca()"

  sleep $SLEEP
done | $DZEN
