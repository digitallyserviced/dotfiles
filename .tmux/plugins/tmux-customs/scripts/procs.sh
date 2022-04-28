#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

typeset syms=('🮠' '🮡' '🮢' '🮣' '🮤' '🮥' '🮦' '🮧' '🮨' '🮩' '🮪' '🮫' '🮬' '🮭' '🮮')
anim(){
  COUNT=0
  LEN=${#syms}
  while sleep 0.25; do
    COUNT=$((COUNT+1))
    SYM=${syms[$COUNT % ${#syms}]}
    printf "%s\r" "${SYM}"
  done
}
running()
{
  local num=$(ps -r -aT -U chris --no-headers | wc -l)
  echo $num
}

procs()
{
  local num=$(ps -aF --no-headers | wc -l)
  echo $num
}

threads()
{
  local threads=$(ps -aT -U chris -o user,spid --no-headers | wc -l)
  echo $num
}

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
