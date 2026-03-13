# resolve aliases after executing
function _reveal_alias() {
  if [[ "$1" != "$2" ]]; then
    print -P "%F{yellow}→ $2%f\n"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook preexec _reveal_alias

# resolve alias inline while typing
function _alias_preview() {
  local first_word="${BUFFER%% *}"
  local rest="${BUFFER#"$first_word"}"
  local def="${aliases[$first_word]}"

  # Remove any previous alias highlight
  region_highlight=("${(@)region_highlight:#*memo=alias_preview}")

  if [[ -n "$def" ]]; then
    POSTDISPLAY="  → $def$rest"
    local start=$#BUFFER
    local end=$(( $#BUFFER + $#POSTDISPLAY ))
    region_highlight+=("$start $end fg=yellow memo=alias_preview")
  else
    POSTDISPLAY=""
  fi
}
zle -N zle-line-pre-redraw _alias_preview

# delete inline alias resolve after executing
function _clear_alias_on_finish() {
  POSTDISPLAY=""
  region_highlight=("${(@)region_highlight:#*memo=alias_preview}")
}
zle -N zle-line-finish _clear_alias_on_finish
