{{- if eq .chezmoi.os "darwin" }}
export SSH_AUTH_SOCK=$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock
{{- else if eq .chezmoi.os "linux" }}
export SSH_AUTH_SOCK=$HOME/.1Password/agent.sock
{{- end }}
