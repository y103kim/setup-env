#!/bin/bash

# Setup packages for ubuntu 20.04
if [ $(lsb_release -d | grep -c "Ubuntu 20.04 LTS") = 1 ]; then
  if [ $(dpkg -l | grep -c build-essential) = 0 ]; then
    sudo apt-get update
    sudo apt-get install -y build-essential python3-venv vim git zsh xclip tree
  fi
fi

# Go to Home
ENV=$(dirname $(realpath ${BASH_SOURCE[0]}))
echo ENV=$ENV
cd $HOME

# TMUX
[ ! -d ~/.tmux ] && git clone https://github.com/gpakosz/.tmux.git
git --git-dir=$HOME/.tmux/.git pull origin master
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
cat $ENV/tmux-extend >> ~/.tmux.conf.local


