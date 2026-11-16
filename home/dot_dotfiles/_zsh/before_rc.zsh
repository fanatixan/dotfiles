export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# compinit -i skips folders compaudit calls insecure (group-writable, or not
# owned by the user, such as the worker's Homebrew for the agent) instead of
# asking. Without a terminal the question aborts compinit, and compdef is gone.
#
# zsh-autocomplete (loaded by antidote) runs compinit itself, after its
# Completions folder is on fpath. An earlier compinit leaves its functions
# undefined: "command not found: _autocomplete__unambiguous" on Tab.
if [[ -f $DOTFILES_FOLDER/_zsh/antidote/rc.zsh ]]; then
  zstyle ':autocomplete::compinit' arguments -i
else
  autoload -Uz compinit
  compinit -i
fi
