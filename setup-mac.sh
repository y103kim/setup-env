brew install tmux
brew install ripgrep
brew install python
brew install neovim
brew install gh
brew install hub

# Go to Home
ENV=$(dirname $(realpath ${BASH_SOURCE[0]}))
echo ENV=$ENV
cd $HOME

#########################  Archive Setup ##########################
BASEPATH=$HOME/env
USR_BASE=$BASEPATH/usr
MY_LIB=$BASEPATH/usr/lib
ARCHIVE=$HOME/env/archive

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