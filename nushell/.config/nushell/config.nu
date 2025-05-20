use std/util "path add"

# BASIC CONFIGS
$env.config.buffer_editor = "nvim"
git config --global core.editor "nvim"
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}

# PATH
let brew_paths = [
  $"($env.HOME)/.linuxbrew/bin"
  "/home/linuxbrew/.linuxbrew/bin"
  "/opt/homebrew/bin"
]

for path in $brew_paths {
  if ($path + "/brew" | path exists) and ($path | path exists) {
    path add $path
    break
  }
}

# ALIAS
alias vim = nvim
alias vi = nvim
alias tmux = zellij

# FUNCTION ALIAS
$env.config.keybindings = [
  {
    name: reload_config
    modifier: Alt_Shift
    keycode: char_r
    mode: [emacs vi_normal vi_insert]
    event: {
      send: executehostcommand,
      cmd: $"clear;source '($nu.env-path)';source '($nu.config-path)';print 'Config reloaded.\n'"
    }
  }
]

# STARSHIP
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
