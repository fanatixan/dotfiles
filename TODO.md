# TODO

## General

- [ ] Add regular cleanup script
- [ ] Migrate from brew autoupdate to a cron job using the Brewfile
- [ ] Mark packages as physical computer only

## Mac

- [ ] Verify if GCC installation is needed in init script
- [ ] Fix sudo TouchID config

## Linux

- [ ] make zsh the default shell
  - `chsh -s $(which zsh)`
  - Problem: `chsh` needs credentials
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
