#!/bin/zsh

CURRENT_DIR="$( cd "$( dirname "$0" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"
# wm_apps="#($CURRENT_DIR/scripts/wm_apps.sh)"
# echo $wm_apps
wm_apps_interpolation=$'#{@wm_apps}'
app_current=$(get_tmux_option "@app-status-current-format")
app=$(get_tmux_option "@app-status-format")
wm_apps=$($HOME/.local/bin/wm '${app_current}' '${app}')

do_interpolation() {
  local input=$1
  local result=""

  result=${input}
  result=${result//$wm_apps_interpolation/$wm_apps}

  echo $result
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
  # echo $option_value
  # echo $wm_apps
  # do_interpolation "${option_value}"
	local new_option_value=$(do_interpolation "$option_value")
  # echo $new_option_value
  # [[ -n "$TMUX" ]] && 
	set_tmux_option "$option" "$new_option_value"
}
set_tmux_options() {
    tmux set-option $@
}

main() {
  # update_tmux_option "@wm_apps"
	update_tmux_option "status-right"
	update_tmux_option "status-left"
  # echo ${wm_apps}
  set_tmux_options -gw "@wm_apps" "${wp_apps}"
}
main
