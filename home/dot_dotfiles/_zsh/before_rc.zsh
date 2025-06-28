export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"
mkdir -p "${ZSH_CACHE_DIR}/completions"

autoload -Uz compinit
compinit
