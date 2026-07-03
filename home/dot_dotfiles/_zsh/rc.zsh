setopt autocd # automatically cd into a directory if you just type its name
setopt notify # report status of background jobs immediately

# History: persist every command immediately so nothing is lost on unclean exit
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history_time # write each command to the file when it finishes, with timestamp + duration
setopt extended_history        # keep timestamp and duration in the history file
setopt hist_ignore_all_dups    # keep only the most recent occurrence of a command
setopt hist_reduce_blanks      # strip superfluous whitespace before saving
setopt hist_ignore_space       # commands starting with a space stay out of history
alias histsync='fc -RI' # import commands from other running sessions on demand
bindkey '^ ' autosuggest-accept
