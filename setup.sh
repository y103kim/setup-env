#!/bin/bash

if [[ "$(which brew)" == "" ]] && [ ! -f $HOME/.linuxbrew/bin/brew ] ; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ "$1" == "as" ] ; then
  if [[ "$(which brew)" == "" ]] && [ -f $HOME/.linuxbrew/bin/brew ]; then
    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
  elif [[ "$(which brew)" == "" ]] && [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  brew install zsh
  brew install tcl-tk
  brew install neovim
  brew install ripgrep
  brew install tmux
  brew install gh
  brew install hub
  brew install python
  brew install go
  brew install nvm
  brew install fzf
  brew install binutils
  brew install gcc
  brew install openjdk
  brew install scala
  brew install sbt

  $(brew --prefix)/opt/fzf/install
fi

SETUP_ENV=$PWD
BASEPATH=$HOME/env
USR_BIN=$(brew --prefix)/bin

#########################  only for mac ##########################
if [[ $OSTYPE == 'darwin'* ]]; then
  echo 'It is macOS'
  mkdir -p $HOME/Library/KeyBindings
  cp DefaultKeyBinding.dict $HOME/Library/KeyBindings

  # VIM
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
fi

#########################  Install pulgins ##########################
# zsh
ZSH_SETUP=$(cat <<-END
setopt EXTENDED_GLOB
if [ ! -d ${ZDOTDIR:-$HOME}/.zprezto ]; then
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
fi
END
)
zsh -c "$ZSH_SETUP"

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
sed -i 's/sorin/powerlevel10k/g' ~/.zpreztorc
cat $SETUP_ENV/zshrc-extend > ~/.zshrc
cp $SETUP_ENV/p10k.zsh ~/.p10k.zsh

# TMUX
[ ! -d $BASEPATH/tmux_conf ] && git clone https://github.com/gpakosz/.tmux.git $BASEPATH/tmux_conf
pushd $BASEPATH/tmux_conf
git checkout .
git pull origin master
cp $BASEPATH/tmux_conf/.tmux.conf ~
cp $BASEPATH/tmux_conf/.tmux.conf.local ~
popd
cat $SETUP_ENV/tmux-extend >> ~/.tmux.conf.local

# ripgrep
cp $SETUP_ENV/_ripgrep $BASEPATH

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
cp $SETUP_ENV/init.vim "${XDG_DATA_HOME:-$HOME/.config/nvim/init.vim}"
nvim +PlugInstall +qall
if [ "$1" == "as" ] ; then
  nvim +PlugUpdate +qall
fi

# COC
cp $SETUP_ENV/coc-settings.json ~/.config/nvim/
if [ "$1" == "as" ] ; then
  export NODE_TLS_REJECT_UNAUTHORIZED=0
  nvim +"CocInstall -sync coc-pyright coc-tsserver coc-prettier coc-json coc-explorer coc-go coc-metals" +qall
  unset NODE_TLS_REJECT_UNAUTHORIZED
fi
nvim +CocUpdateSync +qall

# diff-so-fancy
[ ! -d $BASEPATH/diff-so-fancy ] && git clone https://github.com/so-fancy/diff-so-fancy.git $BASEPATH/diff-so-fancy
pushd $BASEPATH/diff-so-fancy
git checkout .
git pull origin master
cp -rf lib diff-so-fancy $USR_BIN
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
cp $SETUP_ENV/KEYWORDS $BASEPATH
cp $SETUP_ENV/ccc $USR_BIN
cp $SETUP_ENV/dksh $USR_BIN

# chsh
if [ "$1" == "as" ] ; then
  touch ~/.zshrc-local
  sudo chsh -s $(which zsh) doocong
fi
