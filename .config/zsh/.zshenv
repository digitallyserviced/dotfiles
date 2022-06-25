export TMP=${TMP:-${TMPDIR:-/tmp}}
export TMPDIR=$TMP

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_PUBLICSHARE_DIR="$HOME/Public"
export XDG_VIDEOS_DIR="$HOME/Videos"
export XDG_TEMPLATES_DIR="$HOME/Templates"
export LESS="\
  --ignore-case \
  --line-numbers \
  --hilite-search \
  --LONG-PROMPT \
  --no-init \
  --quit-if-one-screen \
  --RAW-CONTROL-CHARS \
  --mouse \
  --wheel-lines=3 \
  --tabs 4 \
  --force \
  --prompt ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]"
export GOPATH="$HOME/go"
export GOROOT="${XDG_DATA_HOME}/go"

export CARGO_HOME="${XDG_DATA_HOME}/cargo"
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
# export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_CONFIG_HOME="$HOME/.config"
export TERM="wezterm"
