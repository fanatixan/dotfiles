# Neovim Cheat Sheet

`<leader>` = Space

## Cursor Movements

> `_` after a key (and in label text) means "takes a character argument" —
> e.g. `F<char>`, `t<char>`, `f<char>`.

### Cursor — horizontal navigation (`h` ↔ `l`, within the line)

```text
+------------------------ start of line
|  +--------------------- first char on line
|  |  +------------------ (find) incl. _ char
|  |  |  +--------------- back to _ char
|  |  |  |  +------------ beginning of paragraph
|  |  |  |  |  +--------- beginning of sentence
|  |  |  |  |  |  +------ beginning of word
|  |  |  |  |  |  |  +--- previous character
0  ^  F_ T_ {  (  b  <------ [ cursor ] ------ >  w  e  )  }  t_ f_ $
                            next character --- +  |  |  |  |  |  |  |
                                 next word ------ +  |  |  |  |  |  |
                               end of word --------- +  |  |  |  |  |
                           end of sentence ------------ +  |  |  |  |
                          end of paragraph --------------- +  |  |  |
                            to _ character ------------------ +  |  |
                       incl. _ char (find) --------------------- +  |
                               end of line ------------------------ +
```

### Cursor — vertical navigation (`j` / `k`, across lines & screen)

```text
    [n]G      --- goto line number
    H         --- top of screen
    k  ^      --- previous line
    [cursor]
    j  v      --- next line
    L         --- bottom of screen
    G         --- goto end of file
```

## Files / search (via Snacks.nvim)

These are identical in vim — same key, same action, different plugin.

| Key           | Action                                   | vim              |
|---------------|------------------------------------------|------------------|
| `<leader>F`   | fuzzy-find files                         | `:Files`         |
| `<leader>B`   | switch buffer                            | `:Buffers`       |
| `<leader>/`   | search contents across project (ripgrep) | `:Rg`            |
| `<leader>l`   | search lines in current file             | `:BLines`        |
| `<leader>r`   | recently opened files                    | `:History`       |
| `<leader>G`   | git-tracked files                        | `:GFiles`        |
| `<leader>I`   | find files **including gitignored**      | `:FilesAll`      |
| `<leader>e`   | toggle file explorer                     | `:NERDTreeToggle`|
| `<leader>E`   | reveal current file in the explorer      | `:NERDTreeFind`  |

Dotfiles are shown/searched everywhere; `.git/` and gitignored paths are not.
Reach gitignored files (`.env` and friends) with `<leader>I`, or toggle them
live: `I` in the explorer, `<a-i>` in a picker (`H` / `<a-h>` do the same for
hidden files). Expect `node_modules` in the results — filter by typing.

## Windows / buffers

| Key              | Action                        |
|------------------|-------------------------------|
| `Ctrl-h j k l`   | move between split windows    |
| `:vsp` / `:sp`   | vertical / horizontal split   |
| `<leader>W`      | save                          |
| `<leader>Q`      | quit                          |
| `:bn` / `:bp`    | next / previous buffer        |
| `:bd`            | close buffer                  |

## LazyVim menus (neovim only)

LazyVim is left completely stock, so its own docs and any answer you find
online apply as written. The shared hotkeys above use the shifted keys to stay
clear of these.

| Key           | Opens                                              |
|---------------|----------------------------------------------------|
| `<leader>f`   | file/find (`ff` files, `fr` recent, `fc` config)   |
| `<leader>b`   | buffer (`bd` delete, `bo` delete others)           |
| `<leader>w`   | window (`wd` delete, `wm` maximize)                |
| `<leader>q`   | quit/session (`qq` quit all, `qs` restore session) |
| `<leader>g`   | git (`gg` lazygit, `gb` blame)                     |
| `<leader>c`   | code (`cf` format, `cd` line diagnostics)          |
| `<leader>s`   | search                                             |
| `<leader>u`   | ui toggles                                         |

## Clipboard & rendering

| Key           | Action                                              |
|---------------|-----------------------------------------------------|
| `y`           | yank to system clipboard (unnamedplus)              |
| `"+p`         | paste from system clipboard                         |
| `<esc>`       | clear search highlight                              |
| `<leader>uw`  | toggle line wrap — **fixes broken wide tables**     |
| `<leader>?`   | toggle this cheat sheet in floating window          |

### Following markdown links

| Key  | On                              | Does                         |
|------|---------------------------------|------------------------------|
| `gd` | `[text](relative/path.md)`      | opens the file in the editor |
| `gx` | `[text](https://...)`, bare URL | opens it in the browser      |

`gd` works with the cursor anywhere on the link, including the link text — it
goes through the **marksman** LSP, so it needs a workspace root (a `.git`
directory or a `.marksman.toml`). It does nothing on `http(s)` links; that is
what `gx` is for. `gx` needs the cursor on the URL itself, which
render-markdown conceals — move onto the line first and the raw text reappears.

### Markdown tables rendering as raw dashes?

Wrap is on for markdown (good for prose, bad for wide tables). A table whose
line is wider than the window wraps across several screen lines, and
render-markdown falls back to raw `|` and `---`. **Press `<leader>uw`** to turn
wrap off and the table snaps into a proper box.

Generated index tables are the usual culprit: padding every cell to the widest
row inflates the separator line to hundreds of columns of dashes, which nothing
can conceal. Emitting `| --- | --- |` unpadded avoids most of it, because
render-markdown hides link URLs and the *displayed* width then collapses.
