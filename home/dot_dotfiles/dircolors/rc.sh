if [ -x /usr/bin/dircolors ]; then
  dircolors_location=$HOME/.dircolors
  test -r $dircolors_location && eval "$(dircolors -b $dircolors_location)" || eval "$(dircolors -b)"
fi
