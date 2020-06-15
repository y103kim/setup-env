#!/bin/bash

# Setup packages for ubuntu 20.04
if [ $(lsb_release -d | grep -c "Ubuntu") = 1 ]; then
  if [ $(dpkg -l | grep -c build-essential) = 0 ]; then
    sudo apt-get update
    sudo apt-get install -y build-essential python3-venv vim git zsh xclip tree
  fi
  [ "$SHELL" != "/bin/zsh" ] && sudo chsh -s /bin/zsh $USER
fi

# Go to Home
ENV=$(dirname $(realpath ${BASH_SOURCE[0]}))
echo ENV=$ENV
cd $HOME

# zsh
read -r -d '' ZSH_SETUP << EOM
if [ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
git --git-dir=${ZDOTDIR:-$HOME}/.zprezto/.git pull origin master
cp ~/.zprezto/runcoms/zlogin ~/.zlogin
cp ~/.zprezto/runcoms/zlogout ~/.zlogout
cp ~/.zprezto/runcoms/zpreztorc ~/.zpreztorc
cp ~/.zprezto/runcoms/zshenv ~/.zshenv
cp ~/.zprezto/runcoms/zprofile ~/.zprofile
cp ~/.zprezto/runcoms/zshrc ~/.zshrc
EOM
zsh -c "$ZSH_SETUP"
sed -i 's/sorin/powerlevel10k/g' ~/.zpreztorc
cat $ENV/zshrc-extend > ~/.zshrc
cp $ENV/p10k.zsh ~/.p10k.zsh

# TMUX
[ ! -d ~/.tmux ] && git clone https://github.com/gpakosz/.tmux.git
git --git-dir=$HOME/.tmux/.git pull origin master
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
cat $ENV/tmux-extend >> ~/.tmux.conf.local

# fzf
[ ! -d ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
[ ! -f ~/.fzf.zsh ] && ~/.fzf/install

