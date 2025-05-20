use std/util "path add"
use ./local.nu

# BASIC CONFIGS
$env.config.buffer_editor = "nvim"
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}
$env.LC_CTYPE = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.LESSCHARSET = "utf-8"

# GIT
git config --global core.editor "nvim"
git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
git config --global interactive.diffFilter "diff-so-fancy --patch"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta       "11"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.func       "146 bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

# Edit files modified in the last commit
def vimgs [] {
    let modified_files = (git log --name-only --format='' -1 | lines | where ($it | str trim | str length) > 0)
    if ($modified_files | is-empty) {
        echo "No files found in the last commit"
        return
    }
    nvim ...$modified_files
}

# Edit files that are currently modified according to git diff
def vimgd [] {
    let modified_files = (git diff --name-only | lines | where ($it | str trim | str length) > 0)
    if ($modified_files | is-empty) {
        echo "No modified files found"
        return
    }
    nvim ...$modified_files
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

