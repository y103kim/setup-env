# ============== 1. CONFIG ZIM ==============
ZIM_CONFIG_FILE=~/.config/zsh/zimrc
ZIM_HOME=~/.cache/zim

if [[ "$(uname -s)" == "Darwin" ]]; then
    ZIM_FW_PATH="/opt/homebrew/opt/zimfw/share/zimfw.zsh"
else
    ZIM_FW_PATH="/home/linuxbrew/.linuxbrew/opt/zimfw/share/zimfw.zsh"
fi

if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source "$ZIM_FW_PATH" init
fi

source ${ZIM_HOME}/init.zsh

# =============== 2. CONFIG OTHER SHELL INTEGRATIONS ===============
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(fzf --zsh)
eval "$(starship init zsh)"

# rg completion
_rg_comp_dir="$HOME/.cache/zsh-completions"
[[ -d "$_rg_comp_dir" ]] || mkdir -p "$_rg_comp_dir"
if [[ ! -f "$_rg_comp_dir/_rg" ]] && (( $+commands[rg] )); then
  rg --generate complete-zsh > "$_rg_comp_dir/_rg"
fi
fpath=("$_rg_comp_dir" $fpath)

# ============== 3. Environment Variables ==============
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ============== 4. Alias ==============
alias vim='nvim'
alias vi='nvim'
alias vimdiff='nvim -d'

# ============== 5. Functions ==============

function _git_edit() {
  # Helper function (internal)
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "Not a git repo"; return 1; }
  local files=("${(@f)$("$@" 2>/dev/null)}")
  local -a edit_list

  for f in $files; do
    [[ -n "$f" ]] && edit_list+=("$git_root/$f")
  done

  if (( ${#edit_list} == 0 )); then
    echo "No matching files found."
    return
  fi

  nvim "${edit_list[@]}"
}

function vimgs() {
  # Edit files modified in the last commit
  _git_edit git log -1 --name-only --format='' HEAD
}

function vimgd() {
  # Edit files currently modified (unstaged)
  _git_edit git diff --name-only
}


