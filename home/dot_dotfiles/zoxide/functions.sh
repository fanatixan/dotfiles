if command -v zoxide >/dev/null 2>&1; then
  cd() {
    z "$@"
    ls
  }

  cdl() {
    z "$@"
    ll
  }
fi
