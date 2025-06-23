#!/usr/bin/env sh

java_version() {
  version=$1
  asdf list all java | grep $version | tail -1
}

asdf plugin add java
asdf install java $(java_version temurin-11)
asdf install java $(java_version temurin-17)
asdf install java $(java_version temurin-21)
asdf install java $(java_version temurin-24)
asdf set -u java $(java_version temurin-24)

asdf plugin add nodejs
asdf install nodejs latest:18
asdf install nodejs latest:20
asdf install nodejs latest:22
asdf set -u nodejs $(asdf latest nodejs 22)

asdf plugin add python
asdf install python latest:3.7
asdf install python latest
asdf set -u python $(asdf latest python)
