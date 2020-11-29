#!/bin/bash

# Go to Home
ENV=$(dirname $(realpath ${BASH_SOURCE[0]}))
echo ENV=$ENV
cd $HOME

#########################  Archive Setup ##########################
BASEPATH=$HOME/env
USR_BASE=$BASEPATH/usr
MY_LIB=$BASEPATH/usr/lib
ARCHIVE=$HOME/env/archive

if [ "$1" == "as" ] ; then
  # Create env base
  mkdir -p $HOME/env/bin
  NODE_VERSION="v14.5.0"
  GO_VERSION=$(curl -s https://golang.org/dl/ | grep -m 1 'class="download downloadBox"' | grep -Poh "\\d+\\.\\d+\\.\\d+")

  # Nodejs
  NVM_DIR="$BASEPATH/nvm"
  mkdir -p $NVM_DIR
  if [ ! -f $NVM_DIR/nvm.sh ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  fi
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

  # Libevent
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/lib/libevent.la ] ; then
    rm -rf $ARCHIVE/libevent*
    gh release download -R libevent/libevent -p "*.tar.gz" -D $ARCHIVE
    LIBEVENT_TAR=$(ls $ARCHIVE/libevent*)
    mkdir -p $BASEPATH/libevent
    tar xf $LIBEVENT_TAR -C $BASEPATH/libevent --strip-components=1
    pushd $BASEPATH/libevent
    ./configure --prefix="$USR_BASE"
    make -j
    make install
    popd
  fi

  # Ncurses
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/lib/libncurses.a ] ; then
    NCURSES_TAR=$ARCHIVE/ncurses-6.2.tar.gz
    NCURSES_URL=https://invisible-mirror.net/archives/ncurses/ncurses-6.2.tar.gz
    [ ! -f $NCURSES_TAR ] && wget -O $NCURSES_TAR $NCURSES_URL
    mkdir -p $BASEPATH/ncurses
    tar xf $NCURSES_TAR -C $BASEPATH/ncurses --strip-components=1
    pushd $BASEPATH/ncurses
    ./configure --prefix="$USR_BASE"
    make -j
    make install
    popd
  fi

  # Tmux
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/bin/tmux ] ; then
    rm -rf $ARCHIVE/tmux*
    gh release download -R tmux/tmux -p "*.tar.gz" -D $ARCHIVE
    TMUX_TAR=$(ls $ARCHIVE/tmux*)
    mkdir -p $BASEPATH/tmux
    tar xf $TMUX_TAR -C $BASEPATH/tmux --strip-components=1
    pushd $BASEPATH/tmux
    CFLAGS="-I$HOME/env/usr/include" LDFLAGS="-Wl,-rpath=$MY_LIB -L$MY_LIB" ./configure --prefix="$USR_BASE"
    make -j
    make install
    popd
  fi
fi

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
[ ! -d $BASEPATH/tmux_conf ] && git clone https://github.com/gpakosz/.tmux.git $BASEPATH/tmux_conf
pushd $BASEPATH/tmux_conf
git checkout .
git pull origin master
cp $BASEPATH/tmux_conf/.tmux.conf ~
cp $BASEPATH/tmux_conf/.tmux.conf.local ~
popd
cat $ENV/tmux-extend >> ~/.tmux.conf.local

# fzf
[ ! -d $BASEPATH/fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git $BASEPATH/fzf
pushd $BASEPATH/fzf
git checkout .
git pull origin master
popd
[ ! -f ~/.fzf.zsh ] && $BASEPATH/fzf/install

# VIM
if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
cp $ENV/vimrc ~/.vimrc
vim +PluginInstall +qall
if [ "$2" == "re" ] ; then
  vim +PluginUpdate +qall
fi
