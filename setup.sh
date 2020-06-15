#!/bin/bash

ENV=$(dirname $(realpath ${BASH_SOURCE[0]}))
echo ENV=$ENV
cd $HOME

# TMUX
[ ! -d ~/.tmux ] && git clone https://github.com/gpakosz/.tmux.git
git --git-dir=$HOME/.tmux/.git pull origin master
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
cat $ENV/tmux-extend >> ~/.tmux.conf.local


