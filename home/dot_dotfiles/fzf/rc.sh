# the keg path, without `brew --prefix fzf` (it loads the Homebrew API)
[ -n "${HOMEBREW_PREFIX:-}" ] && export FZF_BASE=$HOMEBREW_PREFIX/opt/fzf
