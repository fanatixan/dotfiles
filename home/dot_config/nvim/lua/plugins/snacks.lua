-- Show dotfiles in the explorer, the file picker and grep, matching ~/.vimrc
-- (`let NERDTreeShowHidden = 1`, `fd --hidden` in $FZF_DEFAULT_COMMAND, and the
-- overridden :Rg).
--
-- `.git` needs no `exclude` here: snacks already hardcodes `-E .git` in its fd
-- args and `--glob=!.git` in its rg args.
--
-- `ignored` stays at its default (false), so gitignored paths remain out of the
-- way -- fd and ripgrep honour .gitignore in vim too. Toggle either at runtime
-- with `H` (hidden) / `I` (ignored) inside the explorer, or <a-h> / <a-i> in a
-- picker.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = { hidden = true },
        files = { hidden = true },
        grep = { hidden = true },
      },
    },
  },
}
