#!/bin/bash

xrdb=( $(xrdb -query | grep -P "color[0-9]*:" | sort | cut -f 2-) )

# `sort` doesn't quite sort ascending, it sorts "0, 10, 11, 12, ..., 1, 2, 3, ...", so we need to fix.
# while we're at it, we might as well use proper names.

# define array "color" (actually a hash table)
declare -A color

# need this to get the values from xrdb one by one
index=0

# loop over color names
for name in black brightgreen brightyellow brightblue brightmagenta brightcyan brightwhite red green yellow blue magenta cyan white grey brightred; do
	# assign color value from array xrdb to hash "color"
	color[${name}]=${xrdb[$index]}
	# increase "index" by one, so we get the next color value for the next iteration
	((index++))
done

# Just some display demo from here on...
for name in black lgreen lyellow lblue lmagenta lcyan lwhite red green yellow blue magenta cyan white grey lred; do
  echo export "${name^^}"="${color[${name/l/bright}]}"
	# echo -n "^bg(${color[${name}]}) "
      done


SLEEP=1

# Font
FONT="Neep:pixelsize=10"

# Colors
BG="#151515"
FG="#303030"

# RED="#E84F4F"
# LRED="#D23D3D"
#
# GREEN="#B8D68C"
# LGREEN="#A0CF5D"
#
# YELLOW="#E1AA5D"
# LYELLOW="#F39D21"
#
# BLUE="#7DC1CF"
# LBLUE="#4E9FB1"
#
# MAGENTA="#9B64FB"
# LMAGENTA="#8542FF"
#
# CYAN="#6D878D"
# LCYAN="#42717B"

# Geometry
HEIGHT=20
WIDTH=20
X=5
Y=10

# Mail
MAILDIR='/media/data/Mail/Gmail/INBOX/new'
MAILDIR2='/media/data/Mail/Mail/INBOX/new'
