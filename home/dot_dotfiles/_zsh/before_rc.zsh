export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# zsh-autocomplete (loaded by antidote) runs compinit itself, after its
# Completions folder is on fpath. An earlier compinit leaves its functions
# undefined: "command not found: _autocomplete__unambiguous" on Tab.
if [[ ! -f $DOTFILES_FOLDER/_zsh/antidote/rc.zsh ]]; then
  autoload -Uz compinit
  compinit
fi
