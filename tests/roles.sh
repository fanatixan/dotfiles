#!/usr/bin/env sh
# Renders the chezmoi source for every machine role and checks what each role
# gets. Runs on macOS and Linux: the OS is faked with --override-data, so the
# Linux scripts render on a Mac too. lookPath still sees the real machine, so
# the package script is checked on the brew branch (brew must be installed).

set -u

repo=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
failures=0

fail() { echo "FAIL [$role/$os] $1"; failures=$((failures + 1)); }

cz() {
  chezmoi --source "$repo" --destination "$work/home" \
    --config "$work/chezmoi.toml" --persistent-state "$work/state.boltdb" \
    --cache "$work/cache" --override-data "{\"chezmoi\":{\"os\":\"$os\"}}" "$@"
}

use_role() {
  role=$1
  os=$2
  printf '[data]\n  role = "%s"\n' "$role" >"$work/chezmoi.toml"
  managed=$(cz managed --include files,scripts,symlinks 2>&1)
}

render() { cz execute-template <"$repo/home/$1" 2>&1; }

has_target() { echo "$managed" | grep -qx "$1" || fail "missing target $1"; }
no_target() { echo "$managed" | grep -qE "^$1(/|$)" && fail "unexpected target $1"; }
contains() { echo "$2" | grep -q -- "$3" || fail "$1 lacks '$3'"; }
lacks() { echo "$2" | grep -q -- "$3" && fail "$1 has '$3'"; }
empty() { [ -z "$(echo "$2" | tr -d '[:space:]')" ] || fail "$1 is not empty"; }

linux_pkgs=run_onchange_before_10_linux_install_packages.sh.tmpl
mac_pkgs=run_onchange_before_10_mac_install_packages.sh.tmpl
cargo=run_once_before_00_linux_install_cargo.sh.tmpl
zsh=dot_dotfiles/_zsh/run_once_before_00_install_zsh.sh.tmpl
tla=run_onchange_after_40_install_tlaplus.sh.tmpl
rt=run_onchange_after_30_install_asdf_runtimes.sh.tmpl
zplug=dot_dotfiles/_zsh/antidote/dot_zsh_plugins.txt.tmpl

# --- config template: init writes the role it is given --------------------
os=linux role=init
: >"$work/empty.toml" # promptChoiceOnce keeps a role from the real config
cfg=$(chezmoi --source "$repo" --config "$work/empty.toml" execute-template --init \
  --promptChoice "Machine role=worker" <"$repo/home/.chezmoi.toml.tmpl" 2>&1)
contains "config" "$cfg" 'role = "worker"'

# --- workstation (macOS) ----------------------------------------------------
use_role workstation darwin
has_target .ssh/config
has_target .dotfiles/1password/rc.sh
has_target .config/nvim/init.lua
out=$(render "$mac_pkgs")
contains "mac packages" "$out" 'cask "ghostty"'
contains "mac packages" "$out" 'brew "jq"'
contains "mac packages" "$out" 'brew "mosh"'
contains "mac packages" "$out" 'brew "gh"'
contains "mac packages" "$out" 'brew "agda"'
contains "mac packages" "$out" 'brew trust --tap hashicorp/tap'
contains "mac packages" "$out" 'brew "hashicorp/tap/nomad"'
contains "mac packages" "$out" 'mas "Xcode", id: 497799835'
contains "mac packages" "$out" 'mas "Numbers", id: 361304891'
contains "tla+ script" "$(render "$tla")" 'tla2tools.jar'
lacks "mac packages" "$out" 'brew "gradle"'
out=$(render "$rt")
contains "runtimes" "$out" 'version=$(latest java temurin-25)'
contains "runtimes" "$out" 'version=$(latest java corretto-8)'
contains "runtimes" "$out" 'version=$(latest nodejs 26)'
contains "runtimes" "$out" 'version=$(latest gradle)'
# asdf latest prints its errors to stdout; a bare $(asdf latest) hides them (CI failure 2026-11-16)
lacks "runtimes" "$out" 'version=$(asdf latest'
contains "runtimes" "$out" 'uv python install --default 3.15'
contains "runtimes" "$out" 'global="$HOME/.tool-versions"'
no_target .tool-versions
no_target .zshenv
no_target .hushlogin
contains "ghostty" "$(render dot_config/ghostty/config.tmpl)" 'ssh-terminfo'
contains "zsh plugins" "$(render "$zplug")" 'plugins/gh'
out=$(render dot_gitconfig.tmpl)
contains "gitconfig" "$out" 'signingkey = ssh-ed25519 AAAA'

# --- worker (Citadel box, admin login) --------------------------------------
use_role worker linux
has_target .ssh/config
has_target .config/nvim/init.lua
has_target .dotfiles/_zsh/antidote/rc.zsh
no_target .dotfiles/1password
out=$(render "$linux_pkgs")
for p in git ripgrep jq yq tmuxinator neovim direnv asdf git-delta agda \
  just watchexec pandoc unzip; do
  contains "linux packages" "$out" "brew install $p\$"
done
for p in mosh viddy gh act nomad cloudflared ghostty Xcode gradle maven; do
  lacks "linux packages" "$out" "$p"
done
contains "tla+ script" "$(render "$tla")" 'tla2tools.jar'
empty "cargo script" "$(render "$cargo")"
contains "zsh script" "$(render "$zsh")" 'sudo usermod -s "$zsh_path"'
has_target .zshenv
has_target .hushlogin
contains ".zshenv" "$(render dot_zshenv.tmpl)" 'DOTFILES_ENV_LOADED'
out=$(render "$rt")
contains "runtimes" "$out" 'export ASDF_DATA_DIR=/opt/asdf'
contains "runtimes" "$out" 'global=/opt/asdf/tool-versions'
has_target .tool-versions
has_target .dotfiles/zz_asdf/paths
contains "asdf paths" "$(render dot_dotfiles/zz_asdf/paths.tmpl)" 'ASDF_DATA_DIR=/opt/asdf'
out=$(render "$zplug")
contains "zsh plugins" "$out" 'plugins/mvn'
for p in plugins/gh plugins/1password plugins/docker plugins/thefuck; do
  lacks "zsh plugins" "$out" "$p"
done
out=$(render dot_gitconfig.tmpl)
contains "gitconfig" "$out" 'signingkey = ssh-ed25519 AAAA'

# --- agent (Citadel box, agent user) ----------------------------------------
use_role agent linux
has_target .gitconfig
has_target .dotfiles/direnv/rc.zsh
has_target .dotfiles/homebrew/paths
has_target .dotfiles/ripgrep/.ripgreprc
for t in .ssh .dotfiles/1password .config/nvim .config/tmuxinator \
  .dotfiles/_zsh/antidote .dotfiles/_zsh/p10k .vim .p10k.zsh cheatsheets; do
  no_target "$t"
done
lacks "linux packages" "$(render "$linux_pkgs")" 'install'
empty "tla+ script" "$(render "$tla")"
empty "runtimes" "$(render "$rt")"
has_target .tool-versions
has_target .dotfiles/zz_asdf/paths
contains "asdf paths" "$(render dot_dotfiles/zz_asdf/paths.tmpl)" 'ASDF_DATA_DIR=/opt/asdf'
empty "cargo script" "$(render "$cargo")"
empty "zsh script" "$(render "$zsh")"
out=$(render dot_gitconfig.tmpl)
contains "gitconfig" "$out" 'signingkey = ~/.ssh/id_ed25519_signing.pub'
lacks "gitconfig" "$out" 'AAAAC3'

# --- agent applied through sudo: secure_path hides linuxbrew -----------------
# worker and agent always have asdf and git-lfs from the shared brew, so the
# result must not depend on the PATH of whoever runs chezmoi.
chezmoi_bin=$(command -v chezmoi)
cz_nobrew() { PATH=/usr/bin:/bin "$chezmoi_bin" --source "$repo" \
  --destination "$work/home" --config "$work/chezmoi.toml" \
  --persistent-state "$work/state.boltdb" --cache "$work/cache" \
  --override-data "{\"chezmoi\":{\"os\":\"$os\"}}" "$@"; }
for r in agent worker; do
  use_role $r linux
  managed=$(cz_nobrew managed --include files,scripts,symlinks 2>&1)
  has_target .dotfiles/zz_asdf/paths
  contains "gitconfig (no brew on PATH)" \
    "$(cz_nobrew execute-template <"$repo/home/dot_gitconfig.tmpl" 2>&1)" 'filter "lfs"'
done

# --- container (dormant dev containers) -------------------------------------
use_role container linux
no_target .ssh
no_target .dotfiles/1password
out=$(render "$linux_pkgs")
contains "linux packages" "$out" 'install pandoc'
lacks "linux packages" "$out" 'install mosh'
contains "cargo script" "$(render "$cargo")" 'rustup'

lacks "zsh script" "$(render "$zsh")" 'usermod'

# --- macOS container (CI): no workstation-only packages ---------------------
use_role container darwin
out=$(render "$mac_pkgs")
contains "mac packages" "$out" 'brew "jq"'
for p in cask mas 'brew "gh"' 'brew "mosh"' 'hashicorp/tap'; do
  lacks "mac packages" "$out" "$p"
done

# --- static: the apk branch uses the apk name and no -y ---------------------
role=static os=any
# --- static: every package entry uses known keys and roles ------------------
bad=$(yq -r '.packages[] | select(tag == "!!map") | to_entries[]
  | select(.key | test("^(name|brew|apt|apk|cargo|linuxCommand|roles|tap|cask|mas)$") | not)
  | .key' "$repo/home/.chezmoidata/packages.yaml")
[ -z "$bad" ] || fail "unknown package keys: $bad"
bad=$(yq -r '.packages[] | select(tag == "!!map") | .roles // [] | .[]
  | select(test("^(workstation|worker|container)$") | not)' "$repo/home/.chezmoidata/packages.yaml")
[ -z "$bad" ] || fail "unknown package roles: $bad"
bad=$(yq -r '.packages[] | select(tag == "!!map") | select(has("mas") and (has("name") | not)) | .mas' \
  "$repo/home/.chezmoidata/packages.yaml")
[ -z "$bad" ] || fail "mas entries without a name: $bad"
grep -q 'apk add {{ .apk }}' "$repo/home/$linux_pkgs" ||
  fail "apk branch must run 'apk add {{ .apk }}'"

# --- static: brew never asks (Homebrew 7 asks per package in a terminal) ----
for f in $(grep -rlE "brew (install|bundle)" "$repo/home" "$repo/init.sh" | grep -v '/.chezmoidata/'); do
  grep -v '^ *#' "$f" | grep -qE "brew (install|bundle)" || continue
  grep -q 'export HOMEBREW_NO_ASK=1' "$f" || fail "${f#$repo/} runs brew without HOMEBREW_NO_ASK=1"
done

[ "$failures" -eq 0 ] && echo "OK: all role checks passed" || {
  echo "$failures check(s) failed"
  exit 1
}
