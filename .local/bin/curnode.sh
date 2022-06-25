#!/bin/zsh -l  

while sleep 0.5; do
  SOURCE=$(xprop -notype 0s '=$0\n' WM_CLASS 0s '=$0\n' WM_NAME 32i '=$0\n' _NET_WM_PID -id `bspc query -N -n`)
  source <(echo ${SOURCE})
  echo "${_NET_WM_PID};;${(q)WM_CLASS};;${(q)WM_NAME}"
done
# while true; do 
#   bspc subscribe node | stdbuf -o0 -i0 grep node_focus | while read -t 1 line; do
#       bspc query -T -n "${argss[4]}" | fx .client.className;
#       typeset -a argss=(${=line});
#   done
# done
