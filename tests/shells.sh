#!/usr/bin/env bash
# Applies the Linux rendering of the dotfiles (agent role: no plugin managers
# to download) into a throwaway HOME, then starts every kind of zsh and bash
# shell from a clean environment. Each shell must have the env phase exactly
# once (no PATH duplicates, also when nested) and the interactive phase only
# when interactive. Needs zsh and bash 4+ on PATH. SHELLS_LOCALE runs the
# shells in that locale (CI: en_US.UTF-8, whose glibc collation differs from
# macOS); unexpected stderr, such as a command not found, fails the check.

set -u

repo=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
home="$work/home"
mkdir -p "$home"
failures=0

printf '[data]\n  role = "agent"\n' >"$work/chezmoi.toml"
chezmoi --source "$repo" --destination "$home" --config "$work/chezmoi.toml" \
  --persistent-state "$work/state.boltdb" --cache "$work/cache" \
  --override-data '{"chezmoi":{"os":"linux"}}' apply --exclude scripts --force

zsh_bin=$(command -v zsh)
bash_bin=$(command -v bash)
marker="$home/bin" # general/paths prepends it; it must appear exactly once

# run <label> <command...>: clean environment, prints PATH|guard|alias count
run() {
  label=$1
  shift
  out=$(cd "$home" && env -i HOME="$home" PATH=/usr/bin:/bin TERM=dumb \
    ${SHELLS_LOCALE:+LANG="$SHELLS_LOCALE"} \
    ZSH_BIN="$zsh_bin" BASH_BIN="$bash_bin" "$@" 2>"$work/stderr")
  echo "$out"
}

check() { # check <label> <output> <expected marker count> <aliases: yes|no>
  label=$1 out=$2 want=$3 aliases=$4
  path=${out%%|*}
  count=$(echo "$path" | tr ':' '\n' | grep -cx "$marker")
  [ "$count" = "$want" ] || { echo "FAIL [$label] $marker on PATH $count times, want $want"; failures=$((failures + 1)); }
  case "$aliases:$out" in
    yes:*"|aliases=0") echo "FAIL [$label] interactive phase missing"; failures=$((failures + 1)) ;;
    no:*"|aliases=0") ;;
    no:*) echo "FAIL [$label] interactive phase ran in a non-interactive shell"; failures=$((failures + 1)) ;;
  esac
  [ -s "$work/stderr" ] && grep -v -e 'compinit' -e 'No such widget' -e 'job control' -e 'terminal process group' -e 'command not found: \(brew\|direnv\|zoxide\)' -e '\(brew\|direnv\|zoxide\): command not found' "$work/stderr" | grep -q . &&
    { echo "FAIL [$label] stderr:"; sed 's/^/  /' "$work/stderr"; failures=$((failures + 1)); }
}

# aliases=1 when general/aliases defined `ll` (zsh has built-in aliases, so no count)
probe='echo "$PATH|guard=$DOTFILES_ENV_LOADED|aliases=$(alias ll >/dev/null 2>&1 && echo 1 || echo 0)"'

# --- zsh ---------------------------------------------------------------------
check "zsh -c" "$(run x "$zsh_bin" -c "$probe")" 1 no
check "zsh -c nested" "$(run x "$zsh_bin" -c "\$ZSH_BIN -c '$probe'")" 1 no
check "zsh -i" "$(run x "$zsh_bin" -i -c "$probe")" 1 yes
check "zsh -l -i" "$(run x "$zsh_bin" -l -i -c "$probe")" 1 yes
check "zsh -i nested in zsh -i" "$(run x "$zsh_bin" -i -c "\$ZSH_BIN -i -c '$probe'")" 1 yes
check "zsh -l (non-interactive)" "$(run x "$zsh_bin" -l -c "$probe")" 1 no

# --- bash --------------------------------------------------------------------
check "bash -i" "$(run x "$bash_bin" -i -c "$probe")" 1 yes
check "bash -l (non-interactive)" "$(run x "$bash_bin" -l -c "$probe")" 1 no
check "bash -l -i" "$(run x "$bash_bin" -l -i -c "$probe")" 1 yes
check "bash -i nested in zsh -i" "$(run x "$zsh_bin" -i -c "\$BASH_BIN -i -c '$probe'")" 1 yes
check "zsh -c nested in bash -i" "$(run x "$bash_bin" -i -c "\$ZSH_BIN -c '$probe'")" 1 no

# --- the env phase doesn't leak shell options into bash scripts --------------
out=$(run x "$bash_bin" -l -c 'shopt nullglob globstar | tr -s " \t" " " | tr "\n" ","')
case "$out" in
  *"nullglob on"* | *"globstar on"*) echo "FAIL [bash -l] glob options leak: $out"; failures=$((failures + 1)) ;;
esac

[ "$failures" -eq 0 ] && echo "OK: all shell checks passed" || {
  echo "$failures check(s) failed"
  exit 1
}
