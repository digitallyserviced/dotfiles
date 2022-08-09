############################################################################
#    Author: Lucas Burns                                                   #
#     Email: burnsac@me.com                                                #
#      Home: https://github.com/lmburns                                    #
############################################################################

# alias \$= %=

# alias -g G='| rg '
# alias -g H='| head'
# alias -g T='| tail'

alias xp="xplr"
alias xx="xcompress"
alias ca='cargo'
alias cat="bat"
alias tt="taskwarrior-tui"

alias zstats='zstat -sF "%b %e %H:%M:%S"'

alias ctrim='par -vun "cd {} && cargo trim clear" ::: $(fd -td -d1)'

(( ${+commands[stylua]} )) && alias stylua="stylua -c $XDG_CONFIG_HOME/stylua/stylua.toml"
alias :q='exit'
alias ng="noglob"

alias ja="jaime"

(( ${+commands[just]} )) && {
  alias jj='just'
  # For whatever reason, has to be in homedir to have correct completions
  alias .j='just --justfile $HOME/justfile --working-directory $PWD'
  alias .jc='.j --choose'
  alias .je='.j --edit'
  alias .jl='.j --list'
  alias .js='.j --show'

  alias .jr='just --justfile $HOME/projects/rust/rust_justfile --working-directory $PWD'
}

(( ${+commands[pet]} )) && {
  alias pe="pet exec"
  alias pee="pet edit"
}

(( ${+commands[hoard]} )) && {
  alias hd='hoard -c $XDG_CONFIG_HOME/hoard/hoard.toml -h $XDG_CONFIG_HOME/hoard/root'
  alias hde='hoard -c $XDG_CONFIG_HOME/hoard/hoard.toml -h /Volumes/SSD/manual-bkp/hoard'
  alias nhd='$EDITOR $XDG_CONFIG_HOME/hoard/hoard.toml'
  alias hdocs='hoard -c $XDG_CONFIG_HOME/hoard/docs-config -h $XDG_CONFIG_HOME/hoard/docs'
  alias hdocse='hoard -c $XDG_CONFIG_HOME/hoard/docs-config -h /Volumes/SSD/manual-bkp/hoard-docs'
  alias nhdocs='$EDITOR $XDG_CONFIG_HOME/hoard/docs-config'
}

# === zsh-help ==============================================================
alias lynx="lynx -vikeys -accept-all-cookies"

# === general ===================================================================
# alias sudo='doas'
# alias sudo='sudo '
alias usudo='sudo -E -s '
alias _='sudo'
alias __='doas'
alias cp='/bin/cp -ivp'
alias pl='print -rl --'
alias pp='print -Pr --'
alias mv='mv -iv'
# alias mkd='mkdir -pv'

(( ${+commands[exa]} )) && {
  # --ignore-glob=".DS_Store|__*
  alias l='exa -FHb --git --icons'
  alias l.='exa -FHb --git --icons -d .*'
  alias lp='exa -1F'
  alias ll='exa -FlahHgb --git --icons --time-style long-iso --octal-permissions'
  alias ls='exa -Fhb --git --icons'
  alias lse='exa -Flhb --git --sort=extension --icons'
  alias lsm='exa -Flhb --git --sort=modified --icons'
  alias lsz='exa -Flhb --git --sort=size --icons'
  alias lss='exa -Flhb --git --group-directories-first --icons'
  alias lsd='exa -D --icons --git'
  alias tree='exa --icons --git -TL'
  alias lm='tree 1 -@'
  alias ls@='exa -FlaHb --git --icons --time-style long-iso --no-permissions --octal-permissions --no-user -@'
  alias lsb='exa -FlaHBb --git --icons --time-style long-iso --no-permissions --octal-permissions --no-user -@'
  # alias lm='exa -l  --no-user --no-permissions --no-time -@'
}

(( ${+commands[fd]} )) && {
  alias fd='fd -Hi --no-ignore'
  alias fdc='fd --color=always'
  alias fdr='fd --changed-within=20m -d1'
  alias fdrd='fd --changed-within=30m'
  alias fdrr='fd --changed-within=1m'
}

alias chx='chmod ug+x'
alias chmx='chmod -x'
alias lns='ln -siv'
alias kall='killall'
alias kid='kill -KILL'
alias yt='youtube-dl --add-metadata -i'
alias grep="command grep --color=auto --binary-files=without-match --directories=skip"
alias rg="rg --no-ignore"
alias prg="rg --pcre2"
alias frg="rg -F"
alias irg="rg --no-ignore"
alias diff='diff --color=auto'
alias sha='shasum -a 256'
alias wh="whence -f"
alias wa="whence -va"
# alias wm="whence -m"

alias pvim='nvim -u NONE'

# alias f='pushd'
# alias b='popd'
# alias dirs='dirs -v'

(( ${+commands[dua]} )) && alias ncdu='dua i'
(( ${+commands[coreutils]} )) && alias cu='coreutils'

# === configs ===================================================================
alias nzsh='$EDITOR $ZDOTDIR/.zshrc'
alias azsh='$EDITOR $ZDOTDIR/zsh.d/aliases.zsh'
alias bzsh='$EDITOR $ZDOTDIR/zsh.d/keybindings.zsh'
alias ndir='$EDITOR $ZDOTDIR/gruv.dircolors'
alias ezsh='$EDITOR $HOME/.zshenv'
alias ninit='$EDITOR $XDG_CONFIG_HOME/nvim/init.vim'
alias ncoc='$EDITOR $XDG_CONFIG_HOME/nvim/coc-settings.json'
alias niniti='$EDITOR $XDG_CONFIG_HOME/nvim/init.vim +PlugInstall'
alias ninitu='$EDITOR $XDG_CONFIG_HOME/nvim/init.vim +PlugUpdate'
alias ntask='$EDITOR $XDG_CONFIG_HOME/task/taskrc'
alias nlfr='$EDITOR $XDG_CONFIG_HOME/lf/lfrc'
alias nlfrs='$EDITOR $XDG_CONFIG_HOME/lf/scope'
alias nxplr='$EDITOR $XDG_CONFIG_HOME/xplr/init.lua'
alias ngit='$EDITOR $XDG_CONFIG_HOME/git/config'
alias nyab='$EDITOR $XDG_CONFIG_HOME/yabai/yabairc'
alias nskhd='$EDITOR $XDG_CONFIG_HOME/skhd/skhdrc'
alias ntmux='$EDITOR $XDG_CONFIG_HOME/tmux/tmux.conf'
alias nurls='$EDITOR $XDG_CONFIG_HOME/newsboat/urls'
alias nnews='$EDITOR $XDG_CONFIG_HOME/newsboat/config'
alias nw3m='$EDITOR $HOME/.w3m/keymap'
alias ntig='$EDITOR $TIGRC_USER'
alias nmpc='$EDITOR $XDG_CONFIG_HOME/mpd/mpd.conf'
alias nncm='$EDITOR $XDG_CONFIG_HOME/ncmpcpp/bindings'
alias nmutt='$EDITOR $XDG_CONFIG_HOME/mutt/muttrc'
alias nmuch='$EDITOR $XDG_DATA_HOME/mail/.notmuch/hooks/post-new'
alias nsnip='$EDITOR $XDG_CONFIG_HOME/nvim/UltiSnips/all.snippets'
alias nticker='$EDITOR $XDG_CONFIG_HOME/ticker/ticker.yaml'
alias njaime='$EDITOR $XDG_CONFIG_HOME/jaime/config.yml'

alias srct='tmux source $XDG_CONFIG_HOME/tmux/tmux.conf'

# === mail ======================================================================
# ===locations ==================================================================
alias prd='cd $HOME/projects'
alias unx='cd $HOME/Desktop/unix/mac'
alias zfd='cd $ZDOTDIR/functions'
alias zcs='cd $ZDOTDIR/csnippets'
alias zd='cd "$ZDOTDIR"'
alias gitd='cd $HOME/projects/github'
alias perld='cd $HOME/projects/perl'
alias perlb='cd $HOME/mybin/perl'
alias pyd='cd $HOME/projects/python'
alias awkd='cd $HOME/projects/awk'
alias optd='cd $HOME/opt'
alias confd='cd $XDG_CONFIG_HOME'
alias dotd='cd $HOME/opt/dotfiles'
alias locd='cd $XDG_DATA_HOME'
alias docd='cd $HOME/Documents'
alias cvd='cd $HOME/Documents/cv'
alias downd='cd $HOME/Downloads'
alias mbd='cd $HOME/mybin'
alias vwdir='cd $HOME/vimwiki'
alias nvimd='cd /usr/local/share/nvim/runtime'

# === internet / vpn / etc ======================================================
alias b='buku --suggest --colors gMclo'
alias dl='aria2c -x 4 --dir="${HOME}/Downloads/Aria"'
alias dlpaste='aria2c "$(pbpaste)"'
alias toilet='toilet -d /usr/local/figlet/2.2.5/share/figlet/fonts'
alias downl='xh --download'
alias googler='googler --colors bjdxxy'

alias pyn='openpyn'
alias oconn='openpyn us -t 10'
alias spt='speedtest | rg "(Download:|Upload:)"'
alias essh='eval $(ssh-add)'
alias kc='keychain'
alias kck='keychain -k all'

# === fixes ===================================================================
alias xattr='/usr/bin/xattr'
alias id="/usr/bin/id"
alias idh="man /usr/share/man/man1/id.1"

# === github ====================================================================
# alias conf='/usr/bin/git --git-dir=$XDG_DATA_HOME/dotfiles-private --work-tree=$HOME'
# alias xav='/usr/bin/git --git-dir=$XDG_DATA_HOME/dottest --work-tree=$HOME'

# alias cdg='cd "$(git rev-parse --show-toplevel)"'
# alias gua='git remote | xargs -L1 git push --all'
# alias grmssh='ssh git@burnsac.xyz -- grm'
# alias h='git'
# alias g='hub'
# alias gtrr='git ls-tree -r master --name-only | as-tree'
# alias glog='git log --oneline --decorate --graph'
# alias gloga='git log --oneline --decorate --graph --all'

# === other =====================================================================
alias gpg-tui='gpg-tui --style colored -c 98676A'
# alias tno='terminal-notifier'

# alias thumbs='thumbsup --input ./img --output ./gallery --title "images" --theme cards --theme-style style.css && rsync -av gallery root@burnsac.xyz:/var/www/lmburns'

# alias nerdfont='source $XDG_DATA_HOME/fonts/i_all.sh'

alias mpd='mpd ~/.config/mpd/mpd.conf'

# (( ${+commands[tldr]} )) && alias tldru='tldr --update'
# (( ${+commands[assh]} )) && alias hssh="assh wrapper ssh"
#
# (( ${+commands[pueue]} )) && {
#   alias pu='pueue'
#   alias pud='pueued -dc "$XDG_CONFIG_HOME/pueue/pueue.yml"'
# }
# alias .ts='TS_SOCKET=/tmp/ts1 ts'
# alias .nq='NQDIR=/tmp/nq1 nq'
# alias .fq='NQDIR=/tmp/nq1 fq'

# alias sr='sr -browser=w3m'
# alias srg='sr -browser="$BROWSER"'

alias img='/usr/local/bin/imgcat'
alias getmime='file --dereference --brief --mime-type'
# alias cleanzsh='sudo rm -rf /private/var/log/asl/*.asl'

# alias zath='zathura'
# alias n='man'
# alias n='gman'

# alias tn='tmux new-session -s'
# alias tl='tmux list-sessions'

# alias mycli='LESS="-S $LESS" mycli'

# alias pat='bat --style=header'
# alias duso='du -hsx * | sort -rh | bat --paging=always'

# alias ume='um edit'
alias config='/usr/bin/git --git-dir=/home/chris/.cfg/ --work-tree=/home/chris'

alias ls='exa -al --group-directories-first --icons --colour-scale --colour=always' la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'
export DOTBARE_DIR=$HOME/.cfg
export DOTBARE_TREE=$HOME
alias rg='rg --color=always'
alias less='less -r'
alias open='xdg-open'

function dsf() {
    diff -u $@ | delta --theme='Dracula'
}

_hr_osc_precmd(){
  local last=$?
  if [[ "$last" -gt 0 ]]; then
    hrerr $_p9k_preexec_cmd >&2
  elif [[ "$last" -lt 0 ]]; then
    hwarn $_p9k_preexec_cmd >&2
  else
    hrsuccess $_p9k_preexec_cmd >&2
  fi
  
}

function hrsep(){
  local -a dopts=(-s " " -BU -a right)
  local pre=1
  case "$0" in
    herr) dopts+=(-f 1); 
    ;;
    hinfo) dopts+=(-f 14);
    ;;
    hwarn) dopts+=(-f 3);
    ;;
    hsuccess) dopts+=(-f 2);
    ;;
    hrsep) pre=0
    ;;
  esac
  
  local -a cmd=(hr)
  [[ "${pre}" = "1" ]] && {
    local text=(${(U)@:1})
    cmd+=(${dopts[@]} -t "${text}")
  } || {
    cmd=(hr ${@:1})
  } 
  ${cmd[@]}
}

functions -c hrsep herr
functions -c hrsep hinfo
functions -c hrsep hwarn
functions -c hrsep hsuccess

# local -a nogrc=('jobs' 'log' 'stat' 'limit' 'ls' 'history' 'ulimit')
# [[ ! -f "~/.config/zsh/grc-rs-aliases.zsh" ]]  && {
#   for cmd in {/usr/share/grc/conf.*,$HOME/.config/grc-rs/conf.*}; do
#    cmd="${cmd##*conf.}"
#    [[ ${commands[$cmd]} ]] && echo alias "${cmd}"=\"$( which grc-rs ) --colour=on ${cmd}\"
#  done 
# } | grep -vE "${(j.|.)nogrc[@]}" | tee ${ZDOTDIR}/grc-rs-aliases.zsh > /dev/null 2>&1;
# source ${ZDOTDIR}/grc-rs-aliases.zsh
source <(grcalias)
# === rsync =====================================================================
# vim: ft=zsh:et:sw=0:ts=2:sts=2:
