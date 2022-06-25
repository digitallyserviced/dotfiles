#!/bin/zsh

SLEEP=1

# Font
# FONT="-*-snap-*-*-*-*-*-*-*-*-*-*-iso8859-1"
FONT="-artwiz-cure-medium-r-normal-*-10-*-*-*-*-*-*-*"
# FONT="Terminus;size=6"

# Colors
BG="#151515"
FG="#303030"

RED="#E84F4F"

GREEN="#B8D68C"

YELLOW="#E1AA5D"

BLUE="#7DC1CF"

MAGENTA="#9B64FB"

CYAN="#0088CC"

# Geometry
HEIGHT=20
WIDTH=20
X=3
Y=48

while :; do

echo "^fg($RED) CORE ^fg($CYAN)^pa(160)$(grep core ~/.cache/pacmanupdates | wc -l) 
^fg($RED) COMMUNITY ^fg($CYAN)^pa(160)$(grep community ~/.cache/pacmanupdates | wc -l) 
^fg($RED) EXTRA ^fg($CYAN)^pa(160)$(grep extra ~/.cache/pacmanupdates | wc -l) ^pa(117)
^fg($RED) TESTING ^fg($CYAN)^pa(160)$(grep testing ~/.cache/pacmanupdates | wc -l) ^pa(117)
^fg($RED) MULTILIB ^fg($CYAN)^pa(160)$(grep multilib ~/.cache/pacmanupdates | wc -l) ^pa(117)
^ro(119x20)^ib(2)^fg($BLUE)^pa(2)DIGITALLYSERVICED"

done | dzen2 -p -bg $BG -fg $YELLOW -y $Y -x $X -fn $FONT -l 5 -w 219 -ta l -e "onstart=uncollapse;button3=exit"
