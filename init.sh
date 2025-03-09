#!/usr/bin/env sh

# exit on error
set -e

physical_computer=false
if [ "$target_env" = "pc" ] ; then
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
  if [ "$platform" != "Mac" ] && [ "$platform" != "Linux" ] ; then
    halt "Unsupported platform: ${platform}"
  fi  
}

brew_installed() {
  command -v brew &> /dev/null
}

try_install_brew() {
  if ! brew_installed; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || \
    echo "Failed to install Homebrew, going on"
  fi
}

install_chezmoi_binary() {
  sh -c "$(curl -fsLS get.chezmoi.io)" || \
  sh -c "$(wget -qO- get.chezmoi.io)" || \
  halt "Failed to install chezmoi"
  export PATH="$PATH:./bin"
}

install_chezmoi() {
  if brew_installed; then
    brew install chezmoi
  else
    install_chezmoi_binary
  fi
}

init_chezmoi_config() {
  mkdir -p $HOME/.config/chezmoi
  cat >> $HOME/.config/chezmoi/chezmoi.toml << EOF
[onepassword]
  prompt = false
[data]
  physical_computer = $physical_computer

EOF
}

check_platform
try_install_brew
install_chezmoi
init_chezmoi_config
chezmoi init fanatixan
chezmoi doctor
chezmoi apply
chezmoi update
