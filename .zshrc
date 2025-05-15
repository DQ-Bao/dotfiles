# Environment
PATH="${HOME}/.local/bin:${PATH}"
PATH="/c/Program Files/Git/cmd:${PATH}"
PATH="/c/Program Files/PowerShell/7:${PATH}"
PATH="/c/Program Files/Neovim/bin:${PATH}"
PATH="/c/Program Files (x86)/oh-my-posh/bin:${PATH}"
PATH="/c/Python311/Scripts:${PATH}"
PATH="/c/Python311:${PATH}"
PATH="/c/ProgramData/chocolatey/bin:${PATH}"
PATH="/c/Program Files/Java/jdk-21/bin:${PATH}"
PATH="/c/Program Files/dotnet:${PATH}"
PATH="/c/Program Files/CMake/bin:${PATH}"
PATH="/d/apache-maven-3.9.6/bin:${PATH}"
PATH="/d/tools/ffmpeg-master-latest-win64-gpl/bin:${PATH}"
PATH="$(cygpath -u "${LOCALAPPDATA}")/nvim-data/lazy-rocks/hererocks/bin:${PATH}"
PATH="/c/Program Files/nodejs:${PATH}"
PATH="/c/Program Files/PostgreSQL/17/bin:${PATH}"
PATH="/c/Program Files/MySQL/MySQL Server 8.0/bin:${PATH}"
PATH="$(cygpath -u "${USERPROFILE}")/.cargo/bin:${PATH}"
PATH="/c/Program Files/Docker/Docker/resources/bin:${PATH}"
PATH="/c/Program Files/Microsoft SDKs/Azure/CLI2/wbin:${PATH}"
PATH="/c/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.43.34808/bin/Hostx64/x64:${PATH}"
export CATALINA_HOME="C:/Program Files/Apache Software Foundation/Tomcat 10.1"
export JAVA_HOME="C:/Program Files/Java/jdk-21"
export JRE_HOME="C:/Program Files/Java/jdk-21"
export EDITOR="nvim"
export MEMO_DIR="d:/memo"
export BAT_THEME="Kanagawa"

# Plugins
ZSH_CONFIG_DIR="${HOME}/.config/zsh"
[ ! -d "${ZSH_CONFIG_DIR}" ] && mkdir -p "${ZSH_CONFIG_DIR}"

if [ ! -d "${ZSH_CONFIG_DIR}/fast-syntax-highlighting" ]; then
    git clone "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "${ZSH_CONFIG_DIR}/fast-syntax-highlighting"
fi
source "${ZSH_CONFIG_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 

if [ ! -d "${ZSH_CONFIG_DIR}/zsh-completions" ]; then
    git clone "https://github.com/zsh-users/zsh-completions.git" "${ZSH_CONFIG_DIR}/zsh-completions"
fi
fpath+=("${ZSH_CONFIG_DIR}/zsh-completions/src")

if [ ! -d "${ZSH_CONFIG_DIR}/zsh-autosuggestions" ]; then
    git clone "https://github.com/zsh-users/zsh-autosuggestions.git" "${ZSH_CONFIG_DIR}/zsh-autosuggestions"
fi
source "${ZSH_CONFIG_DIR}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" 

if [ ! -d "${ZSH_CONFIG_DIR}/fzf-tab" ]; then
    git clone "https://github.com/Aloxaf/fzf-tab.git" "${ZSH_CONFIG_DIR}/fzf-tab"
fi
autoload -Uz compinit; compinit
source "${ZSH_CONFIG_DIR}/fzf-tab/fzf-tab.plugin.zsh" 

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
