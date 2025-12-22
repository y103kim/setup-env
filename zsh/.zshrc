# === 1. CONFIG ZIM ===
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

# === 2. CONFIG OTHER SHELL INTEGRATIONS ===
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
source <(fzf --zsh)
