# TODO

## General

- [ ] Add regular cleanup script
- [ ] Migrate from brew autoupdate to a cron job using the Brewfile
- [ ] Fix sudo TouchID config
- [ ] Configure cargo with `rustup default stable`

## Mac

- [ ] Verify if GCC installation is needed in init script

## Linux

- [ ] make zsh the default shell
  - `chsh -s $(which zsh)`
  - Problem: `chsh` needs credentials
- [ ] install direnv
- [ ] install zoxide
- [ ] install asdf

## Pipeline

- [ ] Add 4 test machines:
  - Alpine docker
  - Ubuntu docker
  - Ubuntu physical
  - Mac physical
- [ ] Build base images
  - [ ] Alpine
  - [ ] Ubuntu
