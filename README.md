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
- Install [packages](#installed-packages) with `brew`, `apt`, or `apk` (whichever is available)
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

`rc` files might have a `before_` or `after_` prefix to control the order of execution.

Files are loaded in the following order:

1. `before_rc.sh` files
2. Shell specific `before_rc.bash`/`before_rc.zsh` files
3. `rc.sh` files
4. Shell specific `rc.bash`/`rc.zsh` files
5. `after_rc.sh` files
6. Shell specific `after_rc.bash`/`after_rc.zsh` files
7. `alias` files

Within a category, files are loaded in alphabetical order based on their full path.

## Installed Packages

The [home/.chezmoidata/packages.yaml](home/.chezmoidata/packages.yaml) file contains
the list of packages to install.

The file is structured as follows:

```yaml
packages:
  unixLike:                      # packages installed on all Unix-like systems
    - git                        # if only the package name is provided, it is will be searhed in every supported package manager
    - name: tldr                 # we can restrict the supported package managers
      brew: tlrc        
      cargo: tlrc
    - name: fd                   # we can provide different names for different package managers
      brew: fd
      apt: fd-find
      apk: fd
    - name: top-alternative      # or even different packages
      brew: bottom
      apt: btop
      apk: btop
  macos:                         # packages installed only on MacOs
    brews:                       # brew packages
      - gpg
    casks:                       # cask packages
      - 1password@beta
    appstore:                    # appstore packages
      - name: Amphetamine
        id: 937984704

```

The install script tries to use package managers in the following order:

- `brew`
- `apt`
- `apk`
- Linux script
- `cargo`

Since `cargo` not only installs but also compiles the packages, it is only used
if the app is not installed yet. The `name` property is used to check if the package
is installed.

On Linux, every package is installed one-by-one.

On MacOs, a `Brewfile` is created and installed with `brew bundle`.

### Package Manager Search Pages

- [Homebrew](https://formulae.brew.sh/)
- [apt (Debian/Ubuntu)](https://packages.ubuntu.com/)
- [apk (Alpine)](https://pkgs.alpinelinux.org/)
- [General Linux](https://pkgs.org/)
