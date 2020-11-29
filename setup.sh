#!/bin/bash

# Go to Home
ENV=$(dirname $(realpath ${BASH_SOURCE[0]}))
echo ENV=$ENV
cd $HOME

#########################  Archive Setup ##########################
# Create env base
BASEPATH=$HOME/env
ARCHIVE=$HOME/env/archive
mkdir -p $HOME/env/bin
NODE_VERSION="v14.5.0"
GO_VERSION="1.14.6"

# Nodejs
NVM_DIR="$BASEPATH/nvm"
mkdir -p $NVM_DIR
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install node

# Golang
mkdir -p $BASEPATH/go
GO_TAR=$ARCHIVE/go$GO_VERSION.linux-amd64.tar.gz
if [ ! -f $GO_TAR ]; then
  wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz -P $ARCHIVE
fi
tar xf $GO_TAR -C $BASEPATH/go --strip-components=1


#########################  Install pulgins ##########################
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
git --git-dir=$HOME/.tmux/.git checkout .
git --git-dir=$HOME/.tmux/.git pull origin master
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .
cat $ENV/tmux-extend >> ~/.tmux.conf.local

# fzf
[ ! -d ~/.fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
git --git-dir=$HOME/.fzf/.git checkout .
git --git-dir=$HOME/.fzf/.git pull origin master
[ ! -f ~/.fzf.zsh ] && ~/.fzf/install

# VIM
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
cp $ENV/vimrc ~/.vimrc
vim +PluginUpdate +qall
vim +PluginInstall +qall
