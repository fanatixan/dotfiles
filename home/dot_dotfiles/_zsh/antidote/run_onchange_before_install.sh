#!/usr/bin/env sh
# antidote, pinned to a release: the plugins file's pin: needs 2.0+. Reruns when
# the pin changes, and moves an existing clone to it. Bump with
# scripts/bump-zsh-pins.sh.
set -e

antidote_version=v2.3.0
antidote_sha=9bb69ab99c6f05d6e6ae237f7ce222eeeb5b4a14

dir=$HOME/.antidote
[ -d "$dir/.git" ] || git clone --quiet https://github.com/mattmc3/antidote.git "$dir"
if [ "$(git -C "$dir" rev-parse HEAD)" != "$antidote_sha" ]; then
  git -C "$dir" fetch --quiet origin "$antidote_sha"
  git -C "$dir" -c advice.detachedHead=false checkout --quiet "$antidote_sha"
fi
echo "antidote $antidote_version ($antidote_sha)"
