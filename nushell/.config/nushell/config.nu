# BASIC CONFIGS
use std/util "path add"
$env.config.buffer_editor = "nvim"
git config --global core.editor "nvim"

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

# STARSHIP
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
