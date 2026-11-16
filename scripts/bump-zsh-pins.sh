#!/usr/bin/env sh
# Moves every pin: in the zsh plugins file to the plugin's current upstream
# HEAD, and antidote to its newest release tag. Review with `git diff`, run
# the tests, then `chezmoi apply`: the next zsh checks out the new pins.
#
# BUMP_ROOT and GIT_LS_REMOTE exist for tests/bump.sh.

set -eu

root=${BUMP_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}
ls_remote=${GIT_LS_REMOTE:-git ls-remote}
dir=$root/home/dot_dotfiles/_zsh/antidote
plugins=$dir/dot_zsh_plugins.txt.tmpl
install=$dir/run_onchange_before_install.sh

short() { echo "$1" | cut -c1-7; }

# rewrite <file> <awk program> [awk -v assignments...]
rewrite() {
  file=$1 prog=$2
  shift 2
  awk "$@" "$prog" "$file" >"$file.tmp" && mv "$file.tmp" "$file"
}

# --- plugins: the first field is owner/repo, or preset:owner/repo ----------
repos=$(awk '$0 ~ / pin:[0-9a-f]/ { r = $1; sub(/^preset:/, "", r); print r }' "$plugins" | sort -u)
for r in $repos; do
  new=$($ls_remote "https://github.com/$r" HEAD | cut -f1)
  [ ${#new} -eq 40 ] || { echo "can't resolve the HEAD of $r" >&2; exit 1; }
  old=$(awk -v r="$r" '{ x = $1; sub(/^preset:/, "", x) }
    x == r { for (i = 2; i <= NF; i++) if ($i ~ /^pin:/) { print substr($i, 5); exit } }' "$plugins")
  if [ "$old" = "$new" ]; then
    echo "$r: up to date ($(short "$new"))"
    continue
  fi
  rewrite "$plugins" '{ x = $1; sub(/^preset:/, "", x) } x == r { sub(/pin:[0-9a-f]+/, "pin:" new) } { print }' \
    -v r="$r" -v new="$new"
  echo "$r: $(short "$old") -> $(short "$new")"
done

# --- antidote: the newest vX.Y.Z tag; an annotated tag's ^{} line is the commit
tags=$($ls_remote --tags https://github.com/mattmc3/antidote)
version=$(echo "$tags" | awk -F'\t' '{ t = $2; sub(/^refs\/tags\//, "", t); sub(/\^\{\}$/, "", t); print t }' |
  grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' | sort -u | sed 's/^v//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1)
[ -n "$version" ] || { echo "no antidote release tag found" >&2; exit 1; }
version=v$version
sha=$(echo "$tags" | awk -F'\t' -v t="refs/tags/$version" '
  $2 == t "^{}" { peeled = $1 } $2 == t { plain = $1 } END { print (peeled != "" ? peeled : plain) }')
old=$(sed -n 's/^antidote_version=//p' "$install")
if [ "$old" = "$version" ] && grep -qx "antidote_sha=$sha" "$install"; then
  echo "antidote: up to date ($version)"
else
  rewrite "$install" '/^antidote_version=/ { $0 = "antidote_version=" v } /^antidote_sha=/ { $0 = "antidote_sha=" s } { print }' \
    -v v="$version" -v s="$sha"
  echo "antidote: $old -> $version ($(short "$sha"))"
fi
