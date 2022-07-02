zmodload zsh/terminfo
autoload -Uz edit-command-line
autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

typeset -g __local_searching __local_savecursor

# This zle widget replaces the standard widget bound to Up (up-line-or-beginning-search). The
# original widget is bound to Ctrl+Up. The only difference between the two is the history they
# use. The standard widget uses global history while our replacement uses local history.
#
# Ideally, this function would be implemented like this:
#
#   zle .set-local-history 1
#   zle .up-line-or-beginning-search
#   zle .set-local-history 0
#
# This doesn't work though. If you type "foo bar" and press Up once, you'll get the last command
# from local history that starts with "foo bar", such as "foo bar baz". This is great. However, if
# you press Up again, you'll get the previous command from local history that starts with
# "foo bar baz" rather than with "foo bar". This is brokarama.
#
# We can attempt to fix this by replacing "up-line-or-beginning-search" with "up-line-or-search"
# but then we'll be cycling through commands that start with "foo" rather than "foo bar". This is
# craporama.
#
# To solve this problem I copied and modified the definition of down-line-or-beginning-search from
# https://github.com/zsh-users/zsh/blob/master/Functions/Zle/down-line-or-beginning-search. God
# bless Open Source.
function up-line-or-beginning-search-local() {
  emulate -L zsh
  local last=$LASTWIDGET
  zle .set-local-history 1
  if [[ $LBUFFER == *$'\n'* ]]; then
    zle .up-line-or-history
    __local_searching=''
  elif [[ -n $PREBUFFER ]] && zstyle -t ':zle:up-line-or-beginning-search' edit-buffer; then
    zle .push-line-or-edit
  else
    [[ $last = $__local_searching ]] && CURSOR=$__local_savecursor
    __local_savecursor=$CURSOR
    __local_searching=$WIDGET
    zle .history-beginning-search-backward
    zstyle -T ':zle:up-line-or-beginning-search' leave-cursor && zle .end-of-line
  fi
  zle .set-local-history 0
}

# Same as above but for Down.
function down-line-or-beginning-search-local() {
  emulate -L zsh
  local last=$LASTWIDGET
  zle .set-local-history 1
  () {
    if [[ ${+NUMERIC} -eq 0 && ( $last = $__local_searching || $RBUFFER != *$'\n'* ) ]]; then
      [[ $last = $__local_searching ]] && CURSOR=$__local_savecursor
      __local_searching=$WIDGET
      __local_savecursor=$CURSOR
      if zle .history-beginning-search-forward; then
        if [[ $RBUFFER != *$'\n'* ]]; then
          zstyle -T ':zle:down-line-or-beginning-search' leave-cursor && zle .end-of-line
        fi
        return
      fi
      [[ $RBUFFER = *$'\n'* ]] || return
    fi
    __local_searching=''
    zle .down-line-or-history
  }
  zle .set-local-history 0
}

function _dotfile-fuzzy-edit() {
  emulate -L zsh
  autoload -Uz dotfile-edit; 
  zle -N dotfile-edit
  zle dotfile-edit
}
zle -N _dotfile-fuzzy-edit
# Wrap _expand_alias because putting _expand_alias in ZSH_AUTOSUGGEST_CLEAR_WIDGETS won't work.
function my-expand-alias() { zle _expand_alias }

# Shows '...' while completing. No `emulate -L zsh` to pick up dotglob if it's set.
if (( ${+terminfo[rmam]} && ${+terminfo[smam]} )); then
  function expand-or-complete-with-dots() {
    echo -nE - ${terminfo[rmam]}${(%):-"%F{red}...%f"}${terminfo[smam]}
    zle fzf-tab-complete
  }
else
  function expand-or-complete-with-dots() {
    zle fzf-tab-complete
  }
fi

# Similar to fzf-history-widget. Extras:
#
#   - `awk` to remove duplicate
#   - preview pane with syntax highlighting
function fzf-history-widget-unique() {
  emulate -L zsh -o pipefail
  local preview='echo -E {} | cut -c8- | xargs -0 echo -e | echo bat -l bash --color always -pp'
  local selected
  # --margin 00%,0%,10%,0% --height=40% --layout reverse-list 
  selected="$(
    fc -rl 1 | 
    awk '!_[substr($0, 8)]++' | 
    fzf +m --with-nth 2.. -n2..,.. --padding 1% --tiebreak=index --info=inline \
    --border rounded --cycle --preview-window up,10,border-sharp,nohidden \
    --query=$LBUFFER --preview 'echo ${preview}' )"
  local ret=$?
  [[ -n "$selected" ]] && zle vi-fetch-history -n $selected
  zle .reset-prompt
  return ret
}
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

function redraw-prompt() {
  emulate -L zsh
  local chpwd=${1:-0} f
  if (( chpwd )); then
    for f in chpwd $chpwd_functions; do
      (( $+functions[$f] )) && $f &>/dev/null
    done
  fi
  for f in precmd $precmd_functions; do
    (( $+functions[$f] )) && $f &>/dev/null
  done
  zle .reset-prompt && zle -R
}

function dirstack_cdr(){
  local -a reply=()
  cdr -rl
}

function cd-rotate() {
  emulate -L zsh
  while (( $#dirstack )) && ! pushd -q $1 &>/dev/null; do
    popd -q $1
  done
  if (( $#dirstack )); then
    redraw-prompt 1
  fi
}

function cd-back() { cd-rotate +1 }
function cd-forward() { cd-rotate -0 }
function cd-up() { cd .. && redraw-prompt 1 }

function my-pound-insert() {
  emulate -L zsh -o extended_glob
  local lines=("${(@f)BUFFER}")
  local uncommented=(${lines:#'#'*})
  if (( $#uncommented )); then
    local MATCH
    BUFFER="${(pj:\n:)${(@)lines:/(#m)*/#${MATCH#\#}}}"
    zle accept-line
  else
    local lbuf=$LBUFFER cur=$CURSOR
    BUFFER="${(pj:\n:)${(@)lines#\#}}"
    if (( $#lbuf )); then
      lines=("${(@f)lbuf[1,-2]}")
      CURSOR=$((cur-$#lines))
    fi
  fi
}
function add-bracket() {
    local -A keys=('(' ')' '{' '}' '[' ']')
    BUFFER[$CURSOR+1]=${KEYS[-1]}${BUFFER[$CURSOR+1]}
    BUFFER+=$keys[$KEYS[-1]]
}
zle -N add-bracket
autoload -U edit-command-line
function edit-command-line-as-zsh {
    TMPSUFFIX=.zsh
    edit-command-line
    unset TMPSUFFIX
}
zle -N edit-command-line-as-zsh
# }}}2

# }}}1

# 棒棒 M-x
function execute-command() {
    local selected=$(printf "%s\n" ${(k)widgets} | ftb-tmux-popup --reverse --prompt="cmd> " --height=10 )
    zle redisplay
    [[ $selected ]] && zle $selected
}
zle -N execute-command

function toggle-dotfiles() {
  emulate -L zsh
  case $GIT_DIR in
    '')
      export GIT_DIR=~/.dotfiles-public
      export GIT_WORK_TREE=~
    ;;
    ~/.dotfiles-public)
      export GIT_DIR=~/.dotfiles-private
      export GIT_WORK_TREE=~
    ;;
    *)
      unset GIT_DIR
      unset GIT_WORK_TREE
    ;;
  esac
  redraw-prompt 0
}

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N my-expand-alias
zle -N expand-or-complete-with-dots
zle -N up-line-or-beginning-search-local
zle -N down-line-or-beginning-search-local
zle -N cd-back
zle -N cd-forward
zle -N cd-up
zle -N fzf-history-widget-unique
zle -N toggle-dotfiles
zle -N my-pound-insert

bindkey -v
typeset -a ZSH_AUTOSUGGEST_IGNORE_WIDGETS=( 'orig-*' beep run-help set-local-history which-command yank yank-pop 'zle-*' fzf-completion )
typeset -ax ZSH_AUTOSUGGEST_STRATEGY=( dir_history custom_history match_prev_cmd completion )
typeset -a ZSH_AUTOSUGGEST_CLEAR_WIDGETS=( history-search-forward history-search-backward history-beginning-search-forward history-beginning-search-backward history-substring-search-up history-substring-search-down up-line-or-beginning-search down-line-or-beginning-search up-line-or-history down-line-or-history accept-line copy-earlier-word autopair-insert )
typeset -a ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=(  )
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
typeset ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=234'
export ZSH_AUTOSUGGEST_HISTORY_IGNORE='?(#c100,)'
export ZSH_AUTOSUGGEST_COMPLETION_IGNORE='[[:space:]]*'
typeset ZSH_AUTOSUGGEST_ORIGINAL_WIDGET_PREFIX=autosuggest-orig-
typeset -a ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=( end-of-line vi-end-of-line vi-add-eol ) # forward-char vi-forward-char 
typeset -a ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=( forward-word emacs-forward-word vi-forward-word vi-forward-word-end vi-forward-blank-word vi-forward-blank-word-end vi-find-next-char vi-find-next-char-skip )

# Deny fzf bindings. We have our own.
# forward-char vi-forward-char 
# FZF_TAB_SHOW_GROUP=brief
# FZF_TAB_SINGLE_GROUP=()

# fzf-tab reads the value of this binding during initialization.
# bindkey '\t' expand-or-complete-prefix
# # jit-source ~/dotfiles/fzf-tab/fzf-tab.zsh
# # typeset -g ZSH_AUTOSUGGEST_EXECUTE_WIDGETS=()
# typeset -g ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=(
#   end-of-line
#   vi-end-of-line
#   vi-add-eol
#   forward-char     # my removal
#   vi-forward-char  # my removal
# )
# typeset -g ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(
#   history-search-forward
#   history-search-backward
#   history-beginning-search-forward
#   history-beginning-search-backward
#   history-substring-search-up
#   history-substring-search-down
#   up-line-or-beginning-search
#   down-line-or-beginning-search
#   up-line-or-history
#   down-line-or-history
#   accept-line
#   fzf-history-widget-unique            # my addition
#   up-line-or-beginning-search-local    # my addition
#   down-line-or-beginning-search-local  # my addition
#   my-expand-alias                      # my addition
#   fzf-tab-complete                     # my addition
# )
# typeset -g ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS=(
#   forward-word
#   emacs-forward-word
#   vi-forward-word
#   vi-forward-word-end
#   vi-forward-blank-word
#   vi-forward-blank-word-end
#   vi-find-next-char
#   vi-find-next-char-skip
#   forward-char               # my addition
#   vi-forward-char            # my addition
# )
# typeset -g ZSH_AUTOSUGGEST_IGNORE_WIDGETS=(
#   orig-\*
#   beep
#   run-help
#   set-local-history
#   which-command
#   yank
#   yank-pop
#   zle-\*
#   expand-or-complete-prefix  # my addition (to make expand-or-complete-with-dots work with fzf-tab)
# )
# #
