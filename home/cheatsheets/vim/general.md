# vim Cheat Sheet

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

## Copy/Paste

| Mode  | Select   | Copy (yank) | Cut (delete) | Paste (put)         |
|-------|----------|-------------|--------------|---------------------|
| char  | `v`      | `y`         | `d`          | `P` — before cursor |
| line  | `V`      | `Y`         | `D`          | `p` — after cursor  |
| block | `Ctrl-v` | —           | —            | —                   |

## Registers

```text
  ""        the unnamed register (default)
  "a ... "z named registers
  "0 ... "9 last copied/yanked (9 = oldest)
  ".        last inserted text
  "%        current file path
  ":        last executed command
```

Example — using register `a` explicitly:

```text
  "ayy   yank current line into register a
  "Ayy   append another line to register a (uppercase = append)
  "ap    paste register a after the cursor
  :reg a inspect what's in register a
```

## The substitute command

```text
  :%s/foo/bar/gcin
   | |  |   |  |
   | |  |   |  +--> flags:
   | |  |   |         g = global
   | |  |   |         c = confirm
   | |  |   |         i = case insensitive
   | |  |   |         n = number of matches (dry run)
   | |  |   +-----> the replacement
   | |  +---------> the search pattern (regular expression)
   | +------------> the substitute command
   +--------------> apply on whole buffer (file);
                    leave out for current line only
```

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
