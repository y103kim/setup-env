#!/bin/bash

BREW_PATHS=(
  # Linux brew path without root
  "$HOME/.linuxbrew/bin"
  # Linux brew path with root
  "/home/linuxbrew/.linuxbrew/bin"
  # MacOS brew path
  "/opt/homebrew/bin"
)

# Find brew path
for DIR in "${BREW_PATHS[@]}"; do
  if [ -x "$DIR/brew" ]; then
    export PATH="$DIR:$PATH"
    break
  fi
done

# install essential packages
brew install zsh neovim ripgrep zellij fnm fzf starship ripgrep fd diff-so-fancy zimfw stow

# copy keymap for macOS
if [[ $OSTYPE == 'darwin'* ]]; then
  echo 'It is macOS'
  mkdir -p $HOME/Library/KeyBindings
  cp DefaultKeyBinding.dict $HOME/Library/KeyBindings
fi
