{{- if eq.chezmoi.os "darwin" -}}
#!/usr/bin/env bash

mkdir -p $HOME/.1password
ln -s $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $HOME/.1password/agent.sock
{{- end }}
