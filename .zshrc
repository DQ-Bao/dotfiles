# Environment
WIN_HOME=$(cygpath -u "${USERPROFILE}")
WIN_LOCAL=$(cygpath -u "${LOCALAPPDATA}")
export ANDROID_HOME="D:/Android"
export ANDROID_SDK_ROOT="D:/Android"
export ANDROID_AVD_HOME="D:/AndroidAvd"
export CATALINA_HOME="C:/Program Files/Apache Software Foundation/Tomcat 10.1"
export JAVA_HOME="C:/Program Files/Java/jdk-21"
export JRE_HOME="C:/Program Files/Java/jdk-21"
export GOPATH="${WIN_HOME}/go"
export EDITOR="nvim"
export MEMO_DIR="d:/memo"
export BAT_THEME="Kanagawa"
PATH="${HOME}/.local/bin:${PATH}"
PATH="/c/Program Files/Wezterm:${PATH}"
PATH="/c/Program Files/Git/cmd:${PATH}"
PATH="/c/Program Files/PowerShell/7:${PATH}"
PATH="/c/Program Files/Neovim/bin:${PATH}"
PATH="/c/Program Files (x86)/oh-my-posh/bin:${PATH}"
PATH="/c/Python311/Scripts:${PATH}"
PATH="/c/Python311:${PATH}"
PATH="/c/ProgramData/chocolatey/bin:${PATH}"
PATH="/c/Program Files/Java/jdk-21/bin:${PATH}"
PATH="/c/Program Files/dotnet:${PATH}"
PATH="${WIN_HOME}/.dotnet/tools:${PATH}"
PATH="/c/Program Files/CMake/bin:${PATH}"
PATH="/d/apache-maven-3.9.6/bin:${PATH}"
PATH="${WIN_LOCAL}/nvim-data/lazy-rocks/hererocks/bin:${PATH}"
PATH="/c/Program Files/nodejs:${PATH}"
PATH="${WIN_HOME}/.cargo/bin:${PATH}"
PATH="/c/Program Files/Docker/Docker/resources/bin:${PATH}"
PATH="/d/Dev/vendor/ninja:${PATH}"
PATH="/c/Program Files/Go/bin:${PATH}"
PATH="/d/Android/cmdline-tools/19.0/bin:${PATH}"
PATH="/d/Android/build-tools/36.0.0:${PATH}"
PATH="/d/Android/platform-tools:${PATH}"
PATH="/d/Android/emulator:${PATH}"
PATH="/d/zig-x86_64-windows-0.15.1:${PATH}"
PATH="/d/tools/Odin-dev-2026-03:${PATH}"
PATH="/d/tools/kotlinc/bin:${PATH}"
PATH="/d/tools/gradle-9.4.1/bin:${PATH}"

# Plugins
source "${HOME}/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 
fpath+=("${HOME}/.config/zsh/zsh-completions/src")
source "${HOME}/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" 
autoload -Uz compinit; compinit
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

# Aliases
alias so="source ${HOME}/.zshrc"
alias path='echo $PATH | tr ":" "\n"'

alias findd='find . -type d | fzf --preview="eza -la --color=always --group-directories-first --time-style=long-iso --icons {}"'
alias findf='find . -type f | fzf --preview="bat --color=always --style=plain --line-range=:500 {}"'

find () {
    if [ "$#" -eq 0 ]; then
        command find . -type d,f | fzf --preview="if [ -d {} ]; then eza -la --color=always --group-directories-first --time-style=long-iso --icons {}; else bat --color=always --style=plain --line-range=:500 {}; fi"
    else
        command find "$@"
    fi
}
memo () {
    if [ "$#" -eq 0 ]; then
        nvim "${MEMO_DIR}/$(date +%Y-%m-%d).txt"
    else 
        nvim "${MEMO_DIR}/$1.txt"
    fi
}

alias open='eval "nvim \$(find)"'
alias ls="eza -a --icons --group-directories-first --time-style=long-iso"
alias ll="ls -l"
alias make="mingw32-make"
alias grep="grep -nH --color=auto"

alias -g -- --help="--help 2>&1 | bat --language=help --style=plain"

alias now='date "+%a, %b %d, %Y %H:%M:%S"'
alias myip="curl ifconfig.me"
alias weather="curl wttr.in"

eval "$(fzf --zsh)"
