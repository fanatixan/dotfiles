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
  - Enable `sudo` with Touch ID
  - Install Java, NodeJS, and Python with [`asdf`](https://asdf-vm.com/)
  - Configure SSH with public keys and [1Password](https://1password.com/)

## Machine Roles

Every machine has one role, asked once by
[`home/.chezmoi.toml.tmpl`](home/.chezmoi.toml.tmpl) and kept in
`~/.config/chezmoi/chezmoi.toml`. Templates branch on `.role` and on
`.chezmoi.os`.

| Role          | Machine                          | Packages                    | Secrets                  |
| ------------- | -------------------------------- | --------------------------- | ------------------------ |
| `workstation` | Mac                              | all, plus casks and apps    | SSH keys, 1Password      |
| `worker`      | Citadel box, admin login         | lean CLI set (shared brew)  | SSH config, no 1Password |
| `agent`       | Citadel box, agent user          | none, uses the worker brew  | none                     |
| `container`   | dev container (dormant)          | CLI set, cargo fallback     | none                     |

- [`home/.chezmoiignore`](home/.chezmoiignore) holds the role-based exclusions.
- A package in [`packages.yaml`](home/.chezmoidata/packages.yaml) can narrow
  its roles with `roles: [...]`.
- The agent role is offline and non-interactive: tool config only, no
  installers, no prompt or editor extras. Its git commits sign with the box
  key `~/.ssh/id_ed25519_signing.pub`.
- An existing config from before the roles still has `physical_computer`.
  Run `chezmoi init` once; the prompt suggests the matching role.

## Runtimes

[`home/.chezmoidata/runtimes.yaml`](home/.chezmoidata/runtimes.yaml) lists the
language runtimes and build tools that asdf installs (Java, Node, Go, Gradle,
Maven, uv, Yarn) and the Python versions that uv installs. The first version of
each is the global default. The workstation and the worker install them.

On the Citadel box they go into `/opt/asdf` and `/opt/uv`, owned by the worker
and read by the agent, which is offline and can't install versions itself.
`~/.tool-versions` of both users links to `/opt/asdf/tool-versions`. The asdf
shims come from a `paths` file, so non-interactive shells get them too.

## Zsh Plugins

antidote loads the plugins of
[`dot_zsh_plugins.txt.tmpl`](home/dot_dotfiles/_zsh/antidote/dot_zsh_plugins.txt.tmpl).
Every plugin is pinned to a commit (`pin:`, or one `preset:` line for all
ohmyzsh entries), and antidote itself to a release, so every machine runs the
same code. `antidote update` skips pinned plugins.

To update them:

1. Run `scripts/bump-zsh-pins.sh`. It moves each pin to the plugin's current
   upstream commit and antidote to its newest release, and prints what changed.
2. Review `git diff`, then run `tests/roles.sh` and `tests/bump.sh`.
3. Run `chezmoi apply`. The next zsh checks out the new pins.

## Usage

The repo supports dev containers, local machines, and the Citadel box.

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

### Citadel Box

For the admin login on the box (installs Homebrew and the lean package set):

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/fanatixan/dotfiles/refs/heads/main/init-worker.sh)"
```

The agent user is offline, so the admin login applies the agent role from a
local clone that the agent user can read:

```sh
sudo -u agent -H chezmoi init --source /path/to/dotfiles --promptChoice "Machine role=agent" --apply
# later updates: pull the clone as the admin login, then
sudo -u agent -H chezmoi --source /path/to/dotfiles apply
```

## Folder Structure

The `home` directory contains the dotfiles that will be synced to the user's home directory
and scripts that will be executed during the setup.

If a script starts with `run_`, it will be executed during the setup by `chezmoi`.
Also, if a file's or folder's name starts with `dot_`, it will be replace with
`.` in the user's home directory.

The [`.shellrc`](home/dot_shellrc) contains the common configuration for both bash
and ZSH to load.

Shell-specific `.bashrc` and `.zshrc` create a utility function to recursively source
specifically named `.rc` files from the [`.dotfiles`](home/dot_dotfiles/) directory.
The configuration is distributed in different files in subfolders of this directory.

Currently two types of files are supported:

- `rc` files containing general configuration.
  Example: [home/dot_dotfiles/_general/rc.sh](home/dot_dotfiles/_general/rc.sh)
- `aliases` files containing aliases for installed packages.
  Example: [home/dot_dotfiles/bat/aliases](home/dot_dotfiles/bat/aliases)
- `paths` files containing path configuration.
  Example: [home/dot_dotfiles/general/paths](home/dot_dotfiles/general/paths)
- `completion` files that put a tool's `#compdef` completion on `fpath` so the
  `compinit` in [home/dot_dotfiles/_zsh/literal_before_rc.zsh](home/dot_dotfiles/_zsh/literal_before_rc.zsh)
  registers it. They run before the `before_rc` files for exactly that reason.
  Example: [home/dot_dotfiles/ai-kit/completion.zsh](home/dot_dotfiles/ai-kit/completion.zsh)

`rc` files should have one of the following extensions:

- `.bash` for bash.
  Example: [home/dot_dotfiles/zz_asdf/rc.bash](home/dot_dotfiles/zz_asdf/rc.bash)
- `.zsh` for ZSH
  Example: [home/dot_dotfiles/_zsh/_20_p10k/rc.zsh](home/dot_dotfiles/_zsh/_20_p10k/rc.zsh)
- `.sh` for both bash and ZSH
  Example: [home/dot_dotfiles/zz_asdf/rc.sh](home/dot_dotfiles/zz_asdf/rc.sh)

`rc` files might have a `before_` or `after_` prefix to control the order of execution.

Files are loaded in the following order:

1. `paths` files
2. `completion.sh` files
3. Shell specific `completion.bash`/`completion.zsh` files
4. `before_rc.sh` files
5. Shell specific `before_rc.bash`/`before_rc.zsh` files
6. `rc.sh` files
7. Shell specific `rc.bash`/`rc.zsh` files
8. `after_rc.sh` files
9. Shell specific `after_rc.bash`/`after_rc.zsh` files
10. `alias` files
11. `functions.sh` files
12. Shell specific `functions.bash`/`functions.zsh` files

Note that for a non-interactive shell, only `paths` files are loaded.

### Shell Startup on Linux

On Linux (the Citadel box, containers) every shell loads the same dotfiles,
and each part exactly once:

- **Env phase** (`paths` files): `~/.zshenv` runs it for every zsh (login,
  interactive, scripts, `zsh -c`), `~/.bashrc` for bash. An exported guard
  (`DOTFILES_ENV_LOADED`) skips it in child processes, which inherit the
  environment, so nested shells and tmux panes don't duplicate `PATH`.
- **Interactive phase** (everything else): once per interactive shell from
  `~/.zshrc` or `~/.bashrc`. Aliases and functions can't be inherited.
- **zsh is the worker's login shell**, so SSH commands, `su` and tools that
  start `$SHELL` go through `~/.zshenv`. Create the agent user with
  `useradd -s /usr/bin/zsh`.

macOS keeps loading the `paths` files from `~/.zshrc`: `path_helper` in
`/etc/zprofile` would reorder a `PATH` set in `~/.zshenv`.
`tests/shells.sh` starts every kind of shell and checks both phases.

Within a category, files are loaded in alphabetical order based on their full path.

## Installed Packages

The [home/.chezmoidata/packages.yaml](home/.chezmoidata/packages.yaml) file contains
the list of packages to install.

It is one list with one line per package:

```yaml
packages:
  - bat                                     # CLI tool, same name in every package manager
  - { name: fd, apt: fd-find }              # CLI tool with another name per package manager
  - { name: tldr, brew: tlrc, cargo: tlrc } # only these package managers
  - { name: gh, roles: [workstation] }      # limit to roles (default: workstation, worker, container)
  - { name: nomad, tap: hashicorp/tap }     # Homebrew formula from a tap; the tap gets trusted
  - { cask: ghostty }                       # macOS GUI app, workstation only
  - { mas: 937984704, name: Amphetamine }   # Mac App Store app, workstation only
```

The rule for roles: build and dev tools go everywhere, everything else is
workstation only. The agent role installs nothing. `tests/roles.sh` rejects
unknown keys and roles.

The TLA+ command-line tools (`tlc`, `sany`, `pcal`) aren't in Homebrew. A
separate script downloads a pinned `tla2tools.jar` into the Homebrew prefix
(so the Citadel agent user shares it) and needs Java 11+.

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

On MacOs, `brew bundle` installs the packages from a Brewfile that the script
generates into `~/.dotfiles/homebrew/Brewfile`.

### Package Manager Search Pages

- [Homebrew](https://formulae.brew.sh/)
- [apt (Debian/Ubuntu)](https://packages.ubuntu.com/)
- [apk (Alpine)](https://pkgs.alpinelinux.org/)
- [General Linux](https://pkgs.org/)
