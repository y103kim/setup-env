#!/bin/bash

# Find brew path
BREW_PATHS=(
  "$HOME/.linuxbrew/bin"
  "/home/linuxbrew/.linuxbrew/bin"
  "/opt/homebrew/bin"
)

for DIR in "${BREW_PATHS[@]}"; do
  if [ -x "$DIR/brew" ]; then
    export PATH="$DIR:$PATH"
    break
  fi
done

# install essential packages
brew install nushell neovim ripgrep zellij nvm fzf starship

