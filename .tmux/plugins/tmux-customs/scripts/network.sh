#!/bin/bash -

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"
# 🮠🮡🮢🮣     🮠🮡🮢🮣🮤🮥🮦🮧🮨🮩🮪🮫🮬🮭🮮🯰🯱🯲🯳🯴🯵🯶🯷🯸🯹🮼🮵🮶🮷🮸🯊🮋🮊🮉🮈🮇🮆🮅🮄🮃🮂🭻🭺🭹🭸🭷🭶🭯🭮🭭🭬
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
main
