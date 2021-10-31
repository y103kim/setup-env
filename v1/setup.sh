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

  # Openssl
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/bin/openssl ] ; then
    echo "==== openssl reinstall ===="
    OPENSSL_TAR=$ARCHIVE/openssl-1.1.1i.tar.gz
    if [ ! -f $OPENSSL_TAR ]; then
      wget https://www.openssl.org/source/openssl-1.1.1i.tar.gz -P $ARCHIVE
    fi
    mkdir -p $BASEPATH/openssl
    tar xf $OPENSSL_TAR -C $BASEPATH/openssl --strip-components=1
    pushd $BASEPATH/openssl
    ./Configure --prefix="$USR_BASE" linux-x86_64
    make -j
    make install
    popd
  fi

  # Python
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/bin/python ] ; then
    echo "==== python 3.9.1 install ===="
    PYTHON_TAR=$ARCHIVE/Python-3.9.1.tgz
    if [ ! -f $PYTHON_TAR ]; then
      wget https://www.python.org/ftp/python/3.9.1/Python-3.9.1.tgz -P $ARCHIVE
    fi
    mkdir -p $BASEPATH/python
    tar xf $PYTHON_TAR -C $BASEPATH/python --strip-components=1
    pushd $BASEPATH/python
    CFLAGS="-I$HOME/env/usr/include" LDFLAGS="-Wl,-rpath=$MY_LIB -L$MY_LIB" ./configure --prefix="$USR_BASE"
    make -j
    make install
    popd
    ln -sf $USR_BASE/bin/python3 $USR_BASE/bin/python
    ln -sf $USR_BASE/bin/pip3 $USR_BASE/bin/pip
    $USR_BASE/bin/python3 -m pip install yapf
  fi

  # Nodejs
  NVM_DIR="$BASEPATH/nvm"
  mkdir -p $NVM_DIR
  if [ ! -f $NVM_DIR/nvm.sh ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
  fi
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm install lts/fermium
  nvm alias default lts/fermium

  # Golang
  mkdir -p $BASEPATH/go
  GO_TAR=$ARCHIVE/go$GO_VERSION.linux-amd64.tar.gz
  if [ ! -f $GO_TAR ]; then
    wget https://golang.org/dl/go$GO_VERSION.linux-amd64.tar.gz -P $ARCHIVE
  fi
  tar xf $GO_TAR -C $BASEPATH/go --strip-components=1

  # Libevent
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/lib/libevent.la ] ; then
    echo "==== Libevent reinstall ===="
    rm -rf $ARCHIVE/libevent*
    if [ "$PUB_GITHUB_HOST" == "" ]; then
      gh release download -R libevent/libevent -p "*.tar.gz" -D $ARCHIVE
    else
      export GITHUB_HOST=$PUB_GITHUB_HOST
      export GITHUB_TOKEN=$PUB_GITHUB_TOKEN
      gh release download -R libevent/libevent -p "*.tar.gz" -D $ARCHIVE
    fi
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
    echo "==== ncurses reinstall ===="
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
    echo "==== tmux reinstall ===="
    rm -rf $ARCHIVE/tmux*
    if [ "$PUB_GITHUB_HOST" == "" ]; then
      gh release download -R tmux/tmux -p "*.tar.gz" -D $ARCHIVE
    else
      export GITHUB_HOST=$PUB_GITHUB_HOST
      export GITHUB_TOKEN=$PUB_GITHUB_TOKEN
      gh release download -R tmux/tmux -p "*.tar.gz" -D $ARCHIVE
    fi
    TMUX_TAR=$(ls $ARCHIVE/tmux*)
    mkdir -p $BASEPATH/tmux
    tar xf $TMUX_TAR -C $BASEPATH/tmux --strip-components=1
    pushd $BASEPATH/tmux
    CFLAGS="-I$HOME/env/usr/include" LDFLAGS="-Wl,-rpath=$MY_LIB -L$MY_LIB" ./configure --prefix="$USR_BASE"
    make -j
    make install
    popd
  fi

  # Zsh
  if [ "$2" == "re" ] || [ ! -f $USR_BASE/bin/zsh ] ; then
    echo "==== zsh reinstall ===="
    ZSH_URL="https://sourceforge.net/projects/zsh/files/zsh/5.8/zsh-5.8.tar.xz"
    ZSH_TAR=$ARCHIVE/zsh-5.8.tar.xz
    [ ! -f $ZSH_TAR ] && wget -O $ZSH_TAR $ZSH_URL
    mkdir -p $BASEPATH/zsh
    tar xf $ZSH_TAR -C $BASEPATH/zsh --strip-components=1
    pushd $BASEPATH/zsh
    ./configure --prefix="$USR_BASE"
    make -j
    make install
    popd
  fi

  # ripgrep
  if [ "$2" == "re" ] || [ ! -f $BASEPATH/ripgrep/rg ] ; then
    echo "==== ripgrep reinstall ===="
    rm -rf $ARCHIVE/ripgrep*
    if [ "$PUB_GITHUB_HOST" == "" ]; then
      gh release download -R BurntSushi/ripgrep -p "*x86*linux*.tar.gz" -D $ARCHIVE
    else
      export GITHUB_HOST=$PUB_GITHUB_HOST
      export GITHUB_TOKEN=$PUB_GITHUB_TOKEN
      gh release download -R BurntSushi/ripgrep -p "*x86*linux*.tar.gz" -D $ARCHIVE
    fi
    RG_TAR=$(ls $ARCHIVE/ripgrep*)
    mkdir -p $BASEPATH/ripgrep
    tar xf $RG_TAR -C $BASEPATH/ripgrep --strip-components=1
  fi

  # hub
  if [ "$2" == "re" ] || [ ! -f $BASEPATH/hub/bin/hub ] ; then
    echo "==== hub reinstall ===="
    rm -rf $ARCHIVE/hub*
    if [ "$PUB_GITHUB_HOST" == "" ]; then
      gh release download -R github/hub -p "hub-linux-amd64*.tgz" -D $ARCHIVE
    else
      export GITHUB_HOST=$PUB_GITHUB_HOST
      export GITHUB_TOKEN=$PUB_GITHUB_TOKEN
      gh release download -R github/hub -p "hub-linux-amd64*.tgz" -D $ARCHIVE
    fi
    HUB_TAR=$(ls $ARCHIVE/hub*)
    mkdir -p $BASEPATH/hub
    tar xf $HUB_TAR -C $BASEPATH/hub --strip-components=1
  fi

  # neovim
  if [ "$2" == "re" ] || [ ! -f $BASEPATH/nvim/bin/nvim ] ; then
    echo "==== nvim reinstall ===="
    rm -rf $ARCHIVE/nvim-linux64.tar.gz
    if [ "$PUB_GITHUB_HOST" == "" ]; then
      gh release download -R neovim/neovim -p nvim-linux64.tar.gz -D $ARCHIVE
    else
      export GITHUB_HOST=$PUB_GITHUB_HOST
      export GITHUB_TOKEN=$PUB_GITHUB_TOKEN
      gh release download -R neovim/neovim -p nvim-linux64.tar.gz -D $ARCHIVE
    fi
    NVIM_TAR=$ARCHIVE/nvim-linux64.tar.gz
    mkdir -p $BASEPATH/nvim
    tar xf $NVIM_TAR -C $BASEPATH/nvim --strip-components=1
  fi

  # vim-plug
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

#########################  Install pulgins ##########################
# zsh
read -r -d '' ZSH_SETUP << EOM
if [ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
pushd $HOME/.zprezto
git checkout .
git pull origin master
popd
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

# ripgrep
cp $ENV/_ripgrep $BASEPATH

# fzf
[ ! -d $BASEPATH/fzf ] && git clone --depth 1 https://github.com/junegunn/fzf.git $BASEPATH/fzf
pushd $BASEPATH/fzf
git checkout .
git pull origin master
popd
[ ! -f ~/.fzf.zsh ] && $BASEPATH/fzf/install

# fzf-tab
[ ! -d $BASEPATH/fzf-tab ] && git clone https://github.com/Aloxaf/fzf-tab.git $BASEPATH/fzf-tab
pushd $BASEPATH/fzf-tab
git checkout .
git pull origin master
# sed -i 's/ctrl-space:toggle/tab:toggle/g' lib/-ftb-fzf
# sed -i 's/tab:down,//g' lib/-ftb-fzf
popd

# enhancd
[ ! -d $BASEPATH/enhancd ] && git clone https://github.com/b4b4r07/enhancd.git $BASEPATH/enhancd
pushd $BASEPATH/enhancd
git checkout .
git pull origin master
popd

# VIM
mkdir -p "${XDG_DATA_HOME:-$HOME/.config/nvim/}"
cp $ENV/init.vim "${XDG_DATA_HOME:-$HOME/.config/nvim/init.vim}"
nvim +PlugInstall +qall
if [ "$1" == "as" ] ; then
  nvim +PlugUpdate +qall
fi

# COC
cp $ENV/coc-settings.json ~/.config/nvim/
if [ "$1" == "as" ] ; then
  export NODE_TLS_REJECT_UNAUTHORIZED=0
  nvim +"CocInstall -sync coc-pyright coc-tsserver coc-prettier coc-json coc-explorer coc-go" +qall
  unset NODE_TLS_REJECT_UNAUTHORIZED
fi
nvim +CocUpdateSync +qall

# diff-so-fancy
[ ! -d $BASEPATH/diff-so-fancy ] && git clone https://github.com/so-fancy/diff-so-fancy.git $BASEPATH/diff-so-fancy
pushd $BASEPATH/diff-so-fancy
git checkout .
git pull origin master
cp -rf lib diff-so-fancy $BASEPATH/usr/bin
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"
popd

# setup miscs
cp $ENV/KEYWORDS $BASEPATH
cp $ENV/ccc $USR_BASE/bin
cp $ENV/dksh $USR_BASE/bin
