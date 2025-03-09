#!/usr/bin/env bash

# exit on error
set -e

physical_computer=false
if [[ "$1" == "pc" ]] ; then
  physical_computer=true
fi

halt() {
  >&2 echo "$1"
  exit 1
}

platform_type() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
      Linux*)     result="Linux";;
      Darwin*)    result="Mac";;
      CYGWIN*)    result="Cygwin";;
      MINGW*)     result="MinGw";;
      MSYS_NT*)   result="Git";;
      *)          result="UNKNOWN:${unameOut}"
  esac
  echo "$result"
}

check_platform() {
  platform=$(platform_type)
  if [[ "$platform" != "Mac" && "$platform" != "Linux" ]] ; then
    halt "Unsupported platform: ${platform}"
  fi  
}

install_if_not_available() {
  app_name=$1
  install_command="${@:2}"
  which -s $app_name || $install_command
}

init_chezmoi_config() {
  mkdir -p $HOME/.config/chezmoi
  cat >> $HOME/.config/chezmoi/chezmoi.toml << 'EOF'
[onepassword]
    prompt = false
[data]
  {{- $physical_computer := promptBoolOnce . "physical_computer" "Is this a physical computer for daily driving (true) or a container (false)?" -}}

EOF
}

check_platform
install_if_not_available brew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi
chezmoi init
init_chezmoi_config
chezmoi init fanatixan
chezmoi doctor
chezmoi apply
chezmoi update
