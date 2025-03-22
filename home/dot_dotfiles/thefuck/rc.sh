if command -v thefuck 2>&1 >/dev/null; then
  eval $(thefuck --alias --enable-experimental-instant-mode)
fi
