#!/usr/bin/env bash

# sources:
# https://easyosx.net/2024/01/29/enabling-auto-updates-in-homebrew/
# https://github.com/DomT4/homebrew-autoupdate

# install autoupdate
brew tap domt4/autoupdate
# making sudo possible
brew install pinentry-mac
# run it every day and on system boot, show credentials prompt if needed
mkdir -p $HOME/Library/LaunchAgents
brew autoupdate start 86400 --cleanup --upgrade --immediate --sudo
