# global alias
# alias -g H='| head ' T='| tail ' L='| less ' R='| rgc '
# alias -g S='| sort ' U='| uniq '
# alias -g N='>/dev/null '
# # https://roylez.info/2010-03-06-zsh-recent-file-alias/
# alias -g NN="*(oc[1])" NNF="*(oc[1].)" NND="*(oc[1]/)"

# 文件系统相关
alias rd='rm -rd'   md='mkdir -p'
alias rm='rm -i --one-file-system'
alias ls='exa -al --group-directories-first --icons --colour-scale --colour=always' la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'
alias dfh='df -h'  dus='du -sh' del='gio trash' dusa='dus --apparent-size'
alias cp='cp --reflink=auto'
alias bdu='btrfs fi du' bdus='bdu -s'

# pacman
# alias S='yay -S' Syu='yay -Syyu' Rcs='yay -Rcs'
# alias Si='yay -Si' Sl='yay -Sl' Ss='noglob yay -Ss'
# alias Qi='yay -Qi' Ql='yay -Ql' Qs='noglob yay -Qs'
# alias Qm='yay -Qm' Qo='yay -Qo'
# alias Fl='yay -Fl' F='yay -F' Fx='yay -Fx'
# alias Fy='yay -Fy'
# alias U='yay -U'
# alias pikaur='p pikaur'

# git
# https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/
alias gclt='git clone --filter=tree:0'
alias gclb='git clone --filter=blob:none'
alias gcl='git clone --depth=1'

function Qlt() {
  pacman -Ql $1 | cut -d' ' -f2 | tree --fromfile=.
}

function compsize-package {
  sudo compsize $(pacman -Ql $1 | cut -d' ' -f2 | grep -v '/$')
}

function _pacman_packages {
  (( $+functions[_pacman_completions_installed_packages] )) || {
    _pacman 2>/dev/null
  }
  _pacman_completions_installed_packages
}

compdef _pacman_packages Qlt compsize-package

alias zmv='noglob zmv'
alias zcp='zmv -C'
alias zln='zmv -L'

# alias rlwrap="rlwrap "
# alias sudo='sudo '
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

# 从爱呼吸老师那里抄的
# https://github.com/farseerfc/dotfiles/blob/master/zsh/.bashrc#L100-L123
function G() {
    git clone https://git.archlinux.org/svntogit/$1.git/ -b packages/$3 --single-branch $3
    #mv "$3"/trunk/* "$3"
    #rm -rf "$3"/{repos,trunk,.git}
}

function Ge() {
    [ -z "$@" ] && echo "usage: $0 <core/extra package name>: get core/extra package PKGBUILD" && return 1
    for i in $@; do
    	G packages core/extra $i
    done
}

function Gc() {
    [ -z "$@" ] && echo "usage: $0 <community package name>: get community package PKGBUILD" && return 1
    for i in $@; do
    	G community community $i
    done
}

alias ta='tmux attach -t'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tk='tmux kill-session -t'

alias ps_mem='sudo ps_mem'
alias diff='diff --color'
alias yarn='yarnpkg'
alias nnn='nnn -C'
alias vim='nvim'

alias ymp3='youtube-dl -f "bestaudio" -o "~/Music/%(uploader)s/%(title)s.%(ext)s" --no-playlist -x --audio-format mp3 --embed-thumbnail ' 
alias ypl3='youtube-dl -f "bestaudio" -o "~/Music/%(uploader)s/%(playlist)s/%(title)s.%(ext)s" -x --audio-format mp3 --embed-thumbnail'
alias config='/usr/bin/git --git-dir=/home/chris/.cfg/ --work-tree=/home/chris'

alias ls='exa -al --group-directories-first --icons --colour-scale --colour=always' la='ls -la'  lt='ls --tree'  ll='ls -l'  l='ls'

