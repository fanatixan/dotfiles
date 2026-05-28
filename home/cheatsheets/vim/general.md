# vim cheat sheet   (leader = Space)

## Files / search

| Key           | Action                                     |
|---------------|--------------------------------------------|
| `<leader>f`   | fuzzy-find files (fzf + fd)                |
| `<leader>b`   | switch buffer                              |
| `<leader>/`   | search contents across project (ripgrep)   |
| `<leader>l`   | search lines in current file               |
| `<leader>e`   | toggle file explorer (NERDTree)            |
| `<leader>n`   | reveal current file in the tree            |

## Editing basics

| Key             | Action                            |
|-----------------|-----------------------------------|
| `i` / `a`       | insert / append                   |
| `o` / `O`       | open line below / above           |
| `x`             | delete char                       |
| `dd`            | delete line                       |
| `yy` / `p`      | yank line / paste                 |
| `ciw` / `diw`   | change / delete inner word        |
| `u` / `Ctrl-r`  | undo / redo                       |
| `.`             | repeat last change                |
| `gg` / `G`      | top / bottom of file              |
| `:%s/a/b/g`     | replace a with b on every line    |

## Windows / buffers

| Key              | Action                        |
|------------------|-------------------------------|
| `Ctrl-h j k l`   | move between split windows    |
| `:vsp` / `:sp`   | vertical / horizontal split   |
| `<leader>w`      | save                          |
| `<leader>q`      | quit                          |
| `:bn` / `:bp`    | next / previous buffer        |
| `:bd`            | close buffer                  |

## Clipboard

| Key           | Action                                              |
|---------------|-----------------------------------------------------|
| `y`           | yank to Mac pasteboard + client clipboard (auto)    |
| `<leader>y`   | (visual) force-send selection to client clipboard   |
| `"+p`         | paste from system clipboard                         |

## Misc

| Key            | Action                       |
|----------------|------------------------------|
| `<esc><esc>`   | clear search highlight       |
| `:term`        | shell in a split             |
| `<leader>?`    | this cheat sheet (q closes)  |
