#!/usr/bin/env sh

which zsh || exit 0

p10k_folder="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [ ! -d "$p10k_folder" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_folder"
fi
