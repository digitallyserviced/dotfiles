
HISTDB_FILE=$ZDOTDIR/.zsh-history.db
# return the latest used command in the current directory
_zsh_autosuggest_strategy_histdb_top_here() {
    (( $+functions[_histdb_query] )) || return
    local query="
SELECT commands.argv
FROM   history
    LEFT JOIN commands
        ON history.command_id = commands.rowid
    LEFT JOIN places
        ON history.place_id = places.rowid
WHERE commands.argv LIKE '${1//'/''}%'
-- GROUP BY 会导致旧命令的新记录不生效
-- GROUP BY commands.argv
ORDER BY places.dir != '${PWD//'/''}',
	history.start_time DESC
LIMIT 1  
"
    typeset -g suggestion=$(_histdb_query "$query")
}

# ZSH_AUTOSUGGEST_STRATEGY=(histdb_top_here match_prev_cmd completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
# ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_COMPLETION_IGNORE='( |man |pikaur -S )*'
ZSH_AUTOSUGGEST_HISTORY_IGNORE='?(#c50,)'

ZI[COMPINIT_OPTS]=-C; zicompinit; zicdreplay;
zi ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
  atpull'%atclone' pick"clrs.zsh" nocompile'!' \
  atload'zstyle ":completion:*" list-colors “${(s.:.)LS_COLORS}”'
zi light trapd00r/LS_COLORS

GENCOMP_DIR=$XDG_CONFIG_HOME/zsh/completions
zi lucid light-mode for \
    Aloxaf/zsh-histdb \
    Aloxaf/gencomp
# # the first call of zsh-z is slow in HDD, so call it in advance
# zinit ice wait="0" lucid atload="zshz >/dev/null"
# zinit light agkozak/zsh-z
# zi ice wait'1b' from'gh-r' as'program'
# zi light @junegunn/fzf
    
# zstyle ':zce:*' keys 'asdghklqwertyuiopzxcvbnmfj;23456789'
# 

zi ice lucid sbin"bin/fzf -> fzf" sbin"bin/fzf-tmux -> fzf-tmux" \
  atclone"make install;" \
  atpull"%atclone" \
  multisrc"shell/{completion,key-bindings}.zsh"
zi load junegunn/fzf

# zmodload aloxaf/subreap
# subreap

set_fast_theme() {
    FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}alias]='fg=blue'
    FAST_HIGHLIGHT_STYLES[${FAST_THEME_NAME}function]='fg=blue'
}
zi ice lucid has'fzf' atload'enable-fzf-tab'
zi load Aloxaf/fzf-tab

# zi ice wait="0c" lucid # atinit="zpcompinit;zpcdreplay"
zi light zdharma-continuum/fast-syntax-highlighting
zi lucid atload'_zsh_autosuggest_start' light-mode for \
   zsh-users/zsh-autosuggestions
zi light kazhala/dotbare 
# zi ice lucid wait"0b" from"gh-r" as"program" atload'eval "$(mcfly init zsh)"'
# zi light cantino/mcfly

# zi wait'0b' lucid light-mode for \
#       zdharma-continuum/fast-syntax-highlighting 
# zi wait'0b'  lucid light-mode for \
#       zsh-users/zsh-autosuggestions

# zi lucid light-mode for \
#   as'program' \
#     xPMo/zsh-toggle-command-prefix \ 
#   
#     eth-p/bat-extras \ 
#   has'tmux' pick'bin/xpanes' \
#     greymd/tmux-xpanes 
  
zi ice wait lucid
zi load wfxr/forgit
zi ice wait lucid pick'autopair.zsh'
zi load hlissner/zsh-autopair
#
zi ice lucid wait as'program' has'bat' pick'src/*'
zi light eth-p/bat-extras
# zi ice lucid wait as'program' 
# zi light LuRsT/hr
# zi ice lucid wait as'program' 
# zi light 
# zi ice lucid wait as'program' has'jq' pick'reddio' from'gitlab'
# zi light aaronNG/reddio
# zi ice lucid wait as'program' pick'neofetch' atclone"cp neofetch.1 $ZPFX/man/man1" atpull'%atclone'
# zi light dylanaraps/neofetch

# zi snippet OMZ::lib/history.zsh
zi snippet https://raw.githubusercontent.com/csurfer/tmuxrepl/master/tmuxrepl.plugin.zsh
