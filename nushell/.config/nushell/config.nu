use std/util "path add"
source ./local.nu

# Env Variables
$env.LC_CTYPE = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"
$env.LANG = "en_US.UTF-8"
$env.LESSCHARSET = "utf-8"

# CONFIGS
$env.config.show_banner = false
$env.config.buffer_editor = "nvim"
$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}
$env.config.completions = {
  case_sensitive: false
  quick: true
  partial: true
  algorithm: "prefix"
  external: {
    enable: true
    max_results: 100
    completer: null
  }
}
$env.config.edit_mode = "vi"

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
  let git_root = (git rev-parse --show-toplevel)
  let pwd_relative = ($env.PWD | path relative-to $git_root)

  let files = (git log --name-only --format='' -1 | lines)
  let trimmed = ($files | where ($it | str trim | str length) > 0)
  let abs_paths = ($trimmed | each { |f| $git_root | path join $f })
  let modified_files = ($abs_paths | each { |f| $f | path relative-to $env.PWD })

  if ($modified_files | is-empty) {
    echo "No files found in the last commit"
    return
  }
  nvim ...$modified_files
}

# Edit files that are currently modified according to git diff
def vimgd [] {
  let git_root = (git rev-parse --show-toplevel)
  let pwd_relative = ($env.PWD | path relative-to $git_root)

  let files = (git diff --name-only | lines)
  let trimmed = ($files | where ($it | str trim | str length) > 0)
  let abs_paths = ($trimmed | each { |f| $git_root | path join $f })
  let modified_files = ($abs_paths | each { |f| $f | path relative-to $env.PWD })

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

# STARSHIP
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# FNM
fnm env --shell bash
    | lines
    | str replace 'export ' ''
    | str replace -a '"' ''
    | split column '='
    | rename name value
    | where name != "FNM_ARCH" and name != "PATH"
    | reduce -f {} {|it, acc| $acc | upsert $it.name $it.value }
    | load-env

path add $"($env.FNM_MULTISHELL_PATH)/bin"

# Menus
$env.config.menus = [
]

# Keybindings
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
  {
    name: fuzzy_history
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "commandline edit --insert (
        history
        | get command
        | uniq
        | reverse
        | str join (char -i 0)
        | fzf --scheme=history --read0 --layout=reverse --height=40% -q (commandline)
        | decode utf-8
        | str trim
        )"
      }
    ]
  }
  {
    name: fuzzy_filefind
    modifier: control
    keycode: char_t
    mode: [emacs, vi_normal, vi_insert]
    event: [
      {
        send: ExecuteHostCommand
        cmd: "
        let isEmpty = (commandline | str trim | str length) == 0
        let endsWithSpace = commandline | str ends-with ' '
        if ($isEmpty or $endsWithSpace) {
          commandline edit --insert (fzf --height=40% --layout=reverse | decode utf-8 | str trim)
        } else {
          let last = (commandline | split words | last)
          commandline edit --replace ([
            (commandline | split words | drop | str join ' ')
            (fzf --height=40% --layout=reverse -q $last | decode utf-8 | str trim)
          ] | str join ' ')
        }"
      }
    ]
  }
  {
    name: change_dir_with_fzf
    modifier: control
    keycode: char_f
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: ExecuteHostCommand,
      cmd: "cd ( history
      | where cwd !~ '.*[0-9]{4}/[0-9]{2}/[0-9]{2}'
      | sort-by start_timestamp
      | reverse
      | get cwd
      | uniq
      | where $it =~ $env.HOME
      | str replace $env.HOME '~'
      | where $it != '~'
      | first 150
      | str join \"\\n\"
      | fzf --height=40% --layout=reverse
      | decode utf-8
      | str trim
      )"
    }
  }
]
