# All command aliases

# ==============================
# Basic Aliases
# ==============================

alias rel='source ~/.zshrc'
alias cl='clear'
alias e='exit'
#
# ============================================================================
# FILE OPERATIONS
# ============================================================================
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv'
alias mkdir='mkdir -pv'
alias rmf='rm -rf'

# ==============================
# Editor Aliases
# ==============================

alias vi='nvim'

# ==============================
# Development Tools
# ==============================

# Lazy tools
alias lg="lazygit"
alias ldc="lazydocker"

# Node.js
alias nrd='npm run dev'
alias ys='yarn start'
alias yd='yarn dev'

# ==============================
# Docker Aliases
# ==============================

alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# ==============================
# Git Aliases
# ==============================

alias gi="git init"
alias gcl="git clone"

alias gs="git status --short"
alias gd="git diff"
alias gds="gd --staged"

alias ga="git add"
alias gap="git add --patch"
alias gr="git reset"
alias gc="git commit"

alias gp="git push"
alias gu="git pull"

alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gb="git branch"

alias gm="git merge"
alias grb="git rebase"

alias gsw="git switch"

# ==============================
# Clipboard Aliases
# ==============================
alias c='termux-clipboard-set'
alias v='termux-clipboard-get'

# ==============================
# File Manager
# ==============================

alias y='yazi'

# ==============================
# Miscellaneous Aliases
# ==============================
alias sarch="proot-distro login archlinux --user root"
alias arch="proot-distro login archlinux"
alias weather='curl wttr.in/orlando?u'
alias ff='fastfetch'
alias hi='pgrep -x dunst >/dev/null && notify-send "Hi there!" "Welcome to the ${XDG_CURRENT_DESKTOP:-${DESKTOP_SESSION:-$(wmctrl -m 2>/dev/null | grep "Name:" | cut -d" " -f2)}} desktop! 🍃" -i ""'

# ==============================
# TMUX Aliases
# ==============================

alias t='tmux'
alias tl='tmux ls'
alias ta='tmux attach -t'
alias tk='tmux kill-session -t'
alias tn='tmux new -s'
alias td='tmux detach'

# ==============================
# Package Manager 
# ==============================
alias u='pkg update'
alias i='pkg install'
alias r='pkg remove'
alias s='pkg search'

# ==============================
# Directory Navigation
# ==============================

alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# ==============================
# Eza (Enhanced ls)
# ==============================

alias dir="eza --color=always --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias lsp="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user"
alias lsa="eza --color=always --long --git --icons=always -b -a --total-size"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
TREE_IGNORE="node_modules|.git|dist|build|coverage|.next|.cache|vendor"
alias tree="eza --tree --level=3 --icons --git --ignore-glob=\"$TREE_IGNORE\""

# ============================================================================
# SYSTEM INFO
# ============================================================================

alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='btop || htop || top'
alias mem='free -h && echo && ps aux | head -1 && ps aux | sort -rnk 4 | head -5'
alias cpu='ps aux | head -1 && ps aux | sort -rnk 3 | head -5'

# ============================================================================
# NETWORK
# ============================================================================

alias myip="hostname -I | awk '{print \$1}' && echo -n 'External: ' && curl -s ifconfig.me && echo"
alias ports='netstat -tulanp'
alias listening='lsof -P -i -n'

# ============================================================================
# FZF ALIASES
# ============================================================================
alias cdf='fcd'              # Fuzzy cd
alias ch='fhist'             # Command history
alias fk='fkill'             # Kill process
alias fe='fedit'             # Edit file
alias ffenv='fenv'           # Environment variables
alias fgr='fzf_grep'          # Fuzzy grep
alias fzff='ffind'           # Fuzzy file find
