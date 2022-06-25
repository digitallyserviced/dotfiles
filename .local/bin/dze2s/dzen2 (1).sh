#!/bin/bash
pkill -f "dzen2 -p -title-name status_bar"
length=1366
height=10
font="-lucy-tewi2a-medium-r-normal--11-90-75-75-p-58-iso10646-1"

bg=#0a0a0a
fg=$(cat ~/.Xdefaults |grep -i color7 |tail -c 8)
fg2=$(cat ~/.Xdefaults |grep -i color8 |tail -c 8)
red=$(cat ~/.Xdefaults |grep -i color9 |tail -c 8)
darkred=$(cat ~/.Xdefaults |grep -i color1: |tail -c 8)
yellow=$(cat ~/.Xdefaults |grep -i color3 |tail -c 8)
blue=$(cat ~/.Xdefaults |grep -i color6 |tail -c 8)
green=$(cat ~/.Xdefaults |grep -i color10 |tail -c 8)
magenta=$(cat ~/.Xdefaults |grep -i color13 |tail -c 8)
black=$(cat ~/.Xdefaults |grep -i color8 |tail -c 8)

load() {
    mem=$(free -m|awk 'NR==3 {print $3}')
    cpu=$(bc <<< $(ps -eo pcpu |grep -vE '^\s*(0.0|%CPU)' |sed -n '1h;$!H;$g;s/\n/ +/gp'))
    echo -ne "^p(_RIGHT)^p(-310)^fg($blue)⭦ ^fg($fg)$mem^fg($yellow)   ⭥ ^fg($fg)$cpu\r"
}

clock() {
    timea=$(date +'%l:%M %p')
    timeb=$(date +'%a %_d')
    echo "^p(_RIGHT)^p(-113)^fg($magenta)⭧ ^fg($fg)$timea ^fg($fg2)$timeb"

}

music() {
    songa=$(mpc current -f "%artist%")
    songb=$(mpc current -f "%title%")
    if [[ -z $songb ]]; then
        songb=$(mpc current -f "%file%"|cut -d "/" -f2|sed 's/.mp3$//')
    fi
    if [[ -z $(mpc current)  ]]; then
        songa=""; songb=""
    fi
    if [[ $(mpc | sed -n 's/^.*m:\so\(\w\).*$/\1/p') = "f" ]]; then
        muscolor=$black
    else
        muscolor=$darkred
    fi
    echo -ne "^p(_LEFT)^fg($muscolor)⭯ ^fg($fg)$songa ^fg($fg2)$songb\r"
}

volume() {
    sound=$(amixer get Master | sed -n 's/.*\[\([a-z]\+\)\]$/\1/p')
    vol=$(echo "`amixer get Master | sed -n 's/^.*\[\([0-9]\+\)%.*$/\1/p'`/10" | bc)
    on=$(eval printf %${vol}s | sed 's/\s/☷/g')
    off=$(eval printf %$(echo "10 - $vol" | bc)s | sed 's/\s/☷/g')
    if [ "$sound" = "off" ]; then
        echo -ne "^p(_RIGHT)^p(-210)^fg($green)◂⋑ ^fg($darkred)$on^fg($black)$off\r"
    else
        echo -ne "^p(_RIGHT)^p(-210)^fg($green)◂⋑ ^fg($fg)$on^fg($black)$off\r"
    fi
}

while true; do
    volume
    music
    load
    clock
    sleep 1
done |
dzen2 -p -title-name status_bar -fn $font -bg $bg -ta l -geometry ${length}x$height+0+0 -e \
    'button1=exec:urxvt -title todo -name todo -geometry 45x25+$((768 / 2 + 150))+60 -e \
    vim $HOME/todo.patch;button3=exec:kill $(pgrep -n vim)' & disown
