#!/usr/bin/env bash

which zsh || exit 0

oh_my_zsh_folder="${ZSH:-$HOME/.oh-my-zsh}"

if [ ! -f $oh_my_zsh_folder/oh-my-zsh.sh ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
