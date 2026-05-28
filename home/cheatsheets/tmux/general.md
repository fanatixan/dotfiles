# tmux cheat sheet   (prefix = Ctrl-b)

## Sessions / windows

| Binding             | Action                          |
|---------------------|---------------------------------|
| `prefix d`          | detach (session keeps running)  |
| `tmux ls`           | list sessions                   |
| `tmux a -t <name>`  | attach to session               |
| `prefix c`          | new window                      |
| `prefix ,`          | rename window                   |
| `prefix 0` … `9`    | go to window N                  |
| `prefix n` / `p`    | next / previous window          |
| `prefix w`          | window / session picker         |

## Panes

| Binding           | Action                          |
|-------------------|---------------------------------|
| `prefix \|`       | split into left / right         |
| `prefix -`        | split into top / bottom         |
| `prefix h j k l`  | move between panes              |
| `prefix H J K L`  | resize (repeatable)             |
| `prefix z`        | zoom pane (toggle fullscreen)   |
| `prefix x`        | kill pane                       |
| `prefix { }`      | swap pane                       |
| `prefix q`        | show pane numbers               |

## Layouts

| Binding         | Layout                            |
|-----------------|-----------------------------------|
| `prefix Space`  | cycle through built-in layouts    |
| `prefix M-v`    | main-vertical (big left + stack)  |
| `prefix M-h`    | main-horizontal (big top + row)   |
| `prefix M-t`    | tiled (even grid)                 |

## Copy mode (vi keys)

| Binding        | Action                        |
|----------------|-------------------------------|
| `prefix [`     | enter copy mode               |
| `q`            | quit copy mode                |
| `v`            | start selection               |
| `y` / `Enter`  | copy (Mac + client clipboard) |
| `/` / `?`      | search forward / back         |
| `n` / `N`      | next / previous match         |

## Misc

| Binding              | Action                               |
|----------------------|--------------------------------------|
| `prefix r`           | reload config                        |
| `prefix ?`           | this cheat sheet                     |
| `prefix : list-keys` | full auto-generated binding list     |
