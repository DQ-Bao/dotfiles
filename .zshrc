# Environment
WIN_HOME=$(cygpath -u "${USERPROFILE}")
export PIPX_HOME="${HOME}/pipx"
export PIPX_BIN_DIR="${HOME}/.local/bin"
export PIPX_MAN_DIR="${HOME}/.local/share/man"
export ANDROID_HOME="/d/Android"
export ANDROID_SDK_ROOT="/d/Android"
export ANDROID_AVD_HOME="/d/AndroidAvd"
export JAVA_HOME="/c/Program Files/Java/jdk-21"
export JRE_HOME="/c/Program Files/Java/jdk-21"
export GOPATH="${WIN_HOME}/go"
export EDITOR="nvim"
export MEMO_DIR="/d/memo"
export BAT_THEME="Kanagawa"
path+=(
    "${HOME}/.local/bin"
    "/c/Program Files/Wezterm"
    "/c/Program Files/Git/cmd"
    "/c/Program Files/PowerShell/7"
    "/c/Program Files/Neovim/bin"
    "/c/Program Files/Java/jdk-21/bin"
    "/c/Program Files/dotnet"
    "${WIN_HOME}/.dotnet/tools"
    "/c/Program Files/CMake/bin"
    "/d/apache-maven-3.9.6/bin"
    "/c/Program Files/nodejs"
    "${WIN_HOME}/.cargo/bin"
    "/c/Program Files/Docker/Docker/resources/bin"
    "/d/Dev/vendor/ninja"
    "/c/Program Files/Go/bin"
    "/d/Android/cmdline-tools/19.0/bin"
    "/d/Android/build-tools/36.0.0"
    "/d/Android/platform-tools"
    "/d/Android/emulator"
    "/d/zig-x86_64-windows-0.16.0"
    "/d/tools/Odin-dev-2026-03"
    "/d/tools/kotlinc/bin"
    "/d/tools/gradle-9.4.1/bin"
)

# Plugins
fpath+=("${HOME}/.config/zsh/zsh-completions/src")
autoload -Uz compinit; compinit -C
autoload -Uz bashcompinit; bashcompinit

source "${HOME}/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 
source "${HOME}/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" 
source "${HOME}/.config/zsh/fzf-tab/fzf-tab.plugin.zsh" 

# Prompt
eval "$(oh-my-posh init zsh --config ${HOME}/.config/ohmyposh/config.toml)"

# Key bindings
bindkey -v
bindkey "^p" history-search-backward
bindkey "^n" history-search-forward
bindkey "^[w" kill-region
bindkey "^l" autosuggest-accept

zle_highlight+=(paste:none)

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Styles
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

memo () {
    if [ "$#" -eq 0 ]; then
        "$EDITOR" "${MEMO_DIR}/$(date +%Y-%m-%d).txt"
    else 
        "$EDITOR" "${MEMO_DIR}/$1"
    fi
}

# Aliases
alias so="source ${HOME}/.zshrc"
alias path='echo $PATH | tr ":" "\n"'

alias findd='find . -type d | fzf --preview="eza -la --color=always --group-directories-first --time-style=long-iso --icons {}"'
alias findf='find . -type f | fzf --preview="bat --color=always --style=plain --line-range=:500 {}"'
alias finda='find . -type d,f | fzf --preview="if [ -d {} ]; then eza -la --color=always --group-directories-first --time-style=long-iso --icons {}; else bat --color=always --style=plain --line-range=:500 {}; fi"'

alias ls="eza -a --icons --group-directories-first --time-style=long-iso"
alias ll="eza -al --icons --group-directories-first --time-style=long-iso"
alias make="mingw32-make"
alias grep="grep --color=auto"
alias bath="bat --language=help -p"

alias now='date "+%a, %b %d, %Y %H:%M:%S"'
alias weather="curl wttr.in"

eval "$(fzf --zsh)"
