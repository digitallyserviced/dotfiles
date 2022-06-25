
#!/bin/zsh

SLEEP=1

# Font
# FONT="Neep:pixelsize=9"
# FONT="-*-terminus-medium-*-*-*-14-*-*-*-*-*-*-*"
FONT="-artwiz-cure-medium-r-normal-*-*-14-*-*-*-*-*-*"
FONT="-artwiz-smoothansi-medium-*-*-*-*-130-*-*-*-*-*-*"
# FONT="Iosevka Term:size=12"
# Colors
BG="#151515"
FG="#303030"

RED="#e85c51"

GREEN="#7aa4a1"

YELLOW="##fda47f"

BLUE="#2f3239"

MAGENTA="#ad5c7c"

CYAN="##fda47f"

# Geometry
HEIGHT=16
WIDTH=20
X=0
Y=25

pacmanupdate() {
  echo -n CORE: $(grep core ~/.cache/pacupdates | wc -l)
  echo -n " - "
  echo -n COMMUNITY: $(grep community ~/.cache/pacupdates | wc -l)
  echo -n " - "
  echo -n TESTING: $(grep testing ~/.cache/pacupdates | wc -l)
  echo -n " - "
  echo -n EXTRA: $(grep extra ~/.cache/pacupdates | wc -l)
}

count() {
  echo -n $(pacman -Qu | wc -l)
}
# FONT="-jmk-neep-medium-*-normal-*-*-140-*-*-*-*-iso8859-1"
# FONT="-jmk-modd-*-*-*-*-*-120-*-*-*-*-*-*"
TITLE=$1
SUMMARY=$2
ICON=$3
URGENCY=$4

# cat /dev/stdin | tee -a $HOME/.cache/notifystdin
echo "${notifyargs[@]}" "${#notifyargs[@]}" >> /home/chris/.cache/notifyargs


# ^fg($RED)  ^fg($CYAN)^pa(100)$(grep extra ~/.cache/pacupdates | wc -l) ^pa(117)
# ^fg($RED) TESTING ^fg($CYAN)^pa(100)$(grep testing ~/.cache/pacupdates | wc -l) ^pa(117)
# ^fg($RED) MULTILIB ^fg($CYAN)^pa(100)$(grep multilib ~/.cache/pacupdates | wc -l) ^pa(117)

# echo "^fg($RED) ${SUMMARY} ^fg($CYAN) 
# ^fg($RED) ${URGENCY} ^fg($CYAN)
# ^ib(2)^bg($YELLOW)${TITLE}" | dzen2 -p -bg $BG -fg $YELLOW -y $Y -x $X -fn $FONT -l 6 -w 140 -ta l -e "onstart=uncollapse;button3=exit"
# exitbreak              
typeset -A urgencyolor=() 
typeset -A urgencytext=()
urgencycolor[CRITICAL]="#e85c51"
urgencycolor[NORMAL]="#5a93aa"
urgencycolor[LOW]="#ebebeb"
urgencytext[CRITICAL]="#000003"
urgencytext[NORMAL]="#FFFFFF"
urgencytext[LOW]="##2f3239"
BODYWIDTH=$(textwidth "$FONT" "${SUMMARY}")
TITLEWIDTH=$(textwidth "$FONT" "${TITLE}")
echo $URGENCY
# while :; do 
  UBG=${urgencycolor[$URGENCY]}
  UFG=${urgencytext[$URGENCY]}
  UFG=${urgencytext[CRITICAL]}
  echo "^ib(1)^fg($UBG)^r(${TITLEWIDTH}x16)^p(-${TITLEWIDTH})^bg()^fg($UFG)^ib(2)${TITLE} ^fg($UBG)   ^fg()${SUMMARY} " | dzen2 -p 2 -ta l -bg $BG -x $X -y $Y -h $HEIGHT -w $(textwidth "$FONT" "${TITLE}                  ${SUMMARY}") -fn $FONT 
