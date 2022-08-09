#!/bin/zsh

unicode() { local -i a="$1"; local c; printf -v c "\u%08x" "$2"; printf -v $a "$c"; }
unicodes() { local a c; for a; do printf -v c '\\U%08x' "$a"; printf "$c"; done; };


