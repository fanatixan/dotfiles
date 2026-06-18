export ZSH_COMPLETIONS_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/completions"
mkdir -p "$ZSH_COMPLETIONS_DIR"
fpath=("$ZSH_COMPLETIONS_DIR" $fpath)

regen_compdef() {
  local file=$1 tool=$2
  shift 2
  (( $+commands[$tool] )) || return 0
  local comp=$ZSH_COMPLETIONS_DIR/$file
  [[ -s $comp && ! ${commands[$tool]} -nt $comp ]] && return 0
  "$@" >| "$comp" 2>/dev/null
}
