# Dotfiles for fanatixan

[![Container Installation Tests](https://github.com/fanatixan/dotfiles/actions/workflows/pipeline.yml/badge.svg)](https://github.com/fanatixan/dotfiles/actions/workflows/pipeline.yml)

## Purpose

The role of this repo is to make it easier to keep track of my dotfiles
and to make it easier to set up a new machine and dev containers with my
preferred settings and apps.

The supported platforms are:

- MacOS
- Ubuntu/Debian
- Alpine
- Fedora/RHEL (untested)

The solution relies on [`chezmoi`](https://www.chezmoi.io/).

[Usage](#usage) -
[Folder Structure](#folder-structure) -
[Installed Packages](#installed-packages)

## Features

- Install [Homebrew](https://brew.sh/) on supported platforms
- Install [`chezmoi`](https://www.chezmoi.io/)
- Add initial chezmoi configuration
- Install [Oh My Zsh](https://ohmyz.sh/) with [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- Sync dotfiles supporting both bash and ZSH for:
  - `git`
  - `tmux`
  - `asdf`
  - Aliases for installed packages
- Install [packages](#installed-packages) with `brew`, `apt`, `dnf`, or `apk` (whichever is available)
- For MacOs:
  - Configure daily autoupdate for Homebrew
  - Enable `sudo` with Touch ID
  - Install Java, NodeJS, and Python with [`asdf`](https://asdf-vm.com/)
  - Configure SSH with public keys and [1Password](https://1password.com/)

## Usage

The repo supports both dev containers and local machines.

### Dev Containers

To set up a dev container, run the following command as a `postCreateCommand`:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fanatixan/dotfiles/refs/heads/main/init-container.sh)"
```

An example is available in the [`.devcontainer`](.devcontainer) folder.

### Local Machines

For a local machine, run the following command in a terminal:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fanatixan/dotfiles/refs/heads/main/init-pc.sh)"
```

## Folder Structure

The `home` directory contains the dotfiles that will be synced to the user's home directory
and scripts that will be executed during the setup.

If a script starts with `run_`, it will be executed during the setup by `chezmoi`.
Also, if a file's or folder's name starts with `dot_`, it will be replace with
`.` in the user's home directory.

The [`.shellrc`](home/dot_shellrc) contains the common configuration for both bash
and ZSH with a utility function to recursively source specifically named `.rc` files
from the [`.dotfiles`](home/dot_dotfiles/) directory. The configuration is distributed
in different files in subfolders of this directory.

Currently two types of files are supported:

- `rc` files containing general configuration.
  Example: [home/dot_dotfiles/_general/rc.sh](home/dot_dotfiles/_general/rc.sh)
- `alias` files containing aliases for installed packages.
  Example: [home/dot_dotfiles/bat/aliases](home/dot_dotfiles/bat/aliases)

`rc` files should have one of the following extensions:

- `.bash` for bash.
  Example: [home/dot_dotfiles/zz_asdf/rc.bash](home/dot_dotfiles/zz_asdf/rc.bash)
- `.zsh` for ZSH
  Example: [home/dot_dotfiles/_zsh/_20_p10k/rc.zsh](home/dot_dotfiles/_zsh/_20_p10k/rc.zsh)
- `.sh` for both bash and ZSH
  Example: [home/dot_dotfiles/zz_asdf/rc.sh](home/dot_dotfiles/zz_asdf/rc.sh)

Files are loaded in the following order:

1. `rc.sh` files
2. `alias` files
3. Shell specific `rc.bash`/`rc.zsh` files

Within a category, files are loaded in alphabetical order based on their full path.

## Installed Packages

The [home/.chezmoidata/packages.yaml](home/.chezmoidata/packages.yaml) file contains
the list of packages to install.

The file is structured as follows:

```yaml
packages:
  universal:        # packages installed on all platforms
    - bat
  apt:              # packages installed with apt
    - fd-find
  dnf:              # packages installed with dnf
    - rust-fd-find
  apk:              # packages installed with apk
    - fd
  brew:             # packages installed with brew
    brews:          # brew formolae
      - fd
    casks:          # brew casks (only for MacOS on physical machines)
      - 1password
    appstore:       # apps installed with mas from the app store (only for MacOS on physical machines)
      - name: Amphetamine
        id: 937984704
```

`chezmoi` tries to use package managers in the following order:

- `brew`
- `apt`
- `dnf`
- `apk`

If none of them are available, the script will exit with an error.

### Package Manager Search Pages

- [Homebrew](https://formulae.brew.sh/)
- [apt (Debian/Ubuntu)](https://packages.ubuntu.com/)
- [dnf (Fedora/RHEL)](https://packages.fedoraproject.org/)
- [apk (Alpine)](https://pkgs.alpinelinux.org/)
- [General Linux](https://pkgs.org/)
