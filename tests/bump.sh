#!/usr/bin/env sh
# Runs scripts/bump-zsh-pins.sh on a copy of the plugins file and the antidote
# install script, with a stub for `git ls-remote`: every pin must move to the
# stub's commit, antidote to the newest release tag, and comments must stay.

set -u

repo=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
failures=0
fail() { echo "FAIL [bump] $1"; failures=$((failures + 1)); }

antidote=home/dot_dotfiles/_zsh/antidote
mkdir -p "$work/$antidote"
cp "$repo/$antidote/dot_zsh_plugins.txt.tmpl" "$repo/$antidote/run_onchange_before_install.sh" "$work/$antidote/"

# stub: HEAD of every repo is 1111..., antidote has tags v2.3.0, v2.10.0
# (annotated, so the peeled ^{} line holds the commit) and the odd v.1.6.5
cat >"$work/ls-remote" <<'EOF'
#!/bin/sh
case "$*" in
  *--tags*) printf '%s\trefs/tags/v2.3.0\n%s\trefs/tags/v2.10.0\n%s\trefs/tags/v2.10.0^{}\n%s\trefs/tags/v.1.6.5\n' \
    9bb69ab99c6f05d6e6ae237f7ce222eeeb5b4a14 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
    2222222222222222222222222222222222222222 cccccccccccccccccccccccccccccccccccccccc ;;
  *) printf '1111111111111111111111111111111111111111\tHEAD\n' ;;
esac
EOF
chmod +x "$work/ls-remote"

BUMP_ROOT="$work" GIT_LS_REMOTE="$work/ls-remote" sh "$repo/scripts/bump-zsh-pins.sh" >"$work/out" 2>&1 ||
  fail "script failed: $(cat "$work/out")"

plugins="$work/$antidote/dot_zsh_plugins.txt.tmpl"
install="$work/$antidote/run_onchange_before_install.sh"
old=$(grep -oE 'pin:[0-9a-f]{40}' "$plugins" | grep -vc 'pin:1111111111111111111111111111111111111111')
[ "$old" -eq 0 ] || fail "$old pin(s) not bumped"
[ "$(grep -c 'pin:' "$plugins")" -eq "$(grep -c 'pin:' "$repo/$antidote/dot_zsh_plugins.txt.tmpl")" ] ||
  fail "pin count changed"
grep -q 'zsh-dot-up pin:1111111111111111111111111111111111111111 *# navigate' "$plugins" ||
  fail "trailing comment lost"
grep -q 'preset:ohmyzsh/ohmyzsh pin:1111111111111111111111111111111111111111' "$plugins" ||
  fail "preset pin not bumped"
grep -qx 'antidote_version=v2.10.0' "$install" || fail "antidote version not v2.10.0"
grep -qx 'antidote_sha=2222222222222222222222222222222222222222' "$install" ||
  fail "antidote sha is not the peeled commit of v2.10.0"
grep -q 'zsh-autocomplete' "$work/out" || fail "no summary of the changes"

[ "$failures" -eq 0 ] && echo "OK: all bump checks passed" || {
  echo "$failures check(s) failed"
  exit 1
}
