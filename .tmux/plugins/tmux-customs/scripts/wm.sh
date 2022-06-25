#!/bin/zsh

emulate zsh

do_read(){
  while read -t 2 -p line; do
    echo $line
  done
} 
occurrences() {
  local n=0
  : ${1//(#m)$2/$((++n))}
  echo $n
}

getallwinsinfo(){
  typeset -a wins=($(${alldesktopwinsinfo[@]})) 
  reply=(${wins//\=/ })
  reply=($(echo ${reply}))
  typeset -a count=(${(M)reply:#WINDOW})
  REPLY=${#count}
}

(){
  typeset -ga xdotool=(xdotool)
  typeset -ga allsearch=(search --desktop --class '.*')
  typeset -ga alldesktopwins=(${xdotool[@]} ${allsearch[@]})
  typeset -ga wininfo=(getwindowgeometry --shell %@)
  typeset -ga winpid=(getwindowpid %@)
  typeset -ga alldesktopwinsinfo=(${alldesktopwins[@]} ${wininfo[@]} ${winpid[@]})
  typeset -ga currentwininfo=(${xdotool[@]} getwindowfocus -f ${wininfo})

  typeset -a keys=(PID MEM CPU EXE)
  typeset -a psinfo=() winfo=() 
  typeset -a info=() win=() reply=() reply3=() 
  typeset -A wins=() reply2=()
  getallwinsinfo
  # typeset -a winsinfo=($(getallwinsinfo && echo ${reply[@]}))
  typeset -a winsinfo=($(echo ${reply[@]}))
  local wincount=$REPLY
  local -a pids=(${winsinfo[-${wincount},-1]})
  winsinfo=(${winsinfo[1,-${wincount}-1]})
  # echo $winsinfo
  # echo $pids
  # echo $wincount
  while [[ "$wincount" -gt 0 ]]; do
    typeset -A win=(${winsinfo[1,12]})
    winsinfo=(${winsinfo:12})
    local PID=${pids[-${wincount}]}
    typeset -a psinfo=($(ps --no-headers -o pid,pmem,pcpu,comm -p${PID}))
    [[ ${#psinfo} == 4 ]] && win+=(${keys:^psinfo})
    wins[${PID}]="${(kv)win}"
    (( wincount=wincount-1 ))
  done
  echo ${(kvqq)wins}

}
#          
# 8🭨🭪🭬🭮🮤🮥🬸🬴🬛🬫🬺🬻🬗🬤🬴🬸🬲🬷🬨🬕         
exit

main()
{
    local _GETIWL=$(/sbin/iwgetid -r)
    local _GETETH=$(ip a | grep "state UP" | awk '{ORS=""}{print $2}' | cut -d ':' -f 1)
    local _status=${_GETIWL:-$_GETETH}
    local _status2="${_status:-Down}"
    ## Format output
    local format=$(get_tmux_option @network_format "  %16s ")
    printf "$format" "${_status2}"
}
anim
