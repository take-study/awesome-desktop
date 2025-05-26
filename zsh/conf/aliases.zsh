# Zsh Aliases Configuration

# Basic file operations
alias ll='ls -alF --color=auto'
alias la='ls -alA --color=auto'
alias l='ls -CF --color=auto'
alias ls='ls --color=auto'
alias lt='ls -alFh --color=auto | head -20'  # Limit to 20 items
alias ltr='ls -alFhtr --color=auto'          # Sort by time, newest last

# Directory operations
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Make directories with parents
alias mkdir='mkdir -pv'

# Copy and move with verbose output
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv --preserve-root'

# Disk usage
alias du='du -kh'
alias df='df -kTh'
alias free='free -h'

# Grep with color
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='htop'
alias jobs='jobs -l'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias wget='wget -c'
alias curl='curl -L'

# Text editors
alias vi='nvim'
alias vim='nvim'
alias nano='nvim'

# Git aliases (if git is available)
if command -v git >/dev/null 2>&1; then
    alias g='git'
    alias ga='git add'
    alias gaa='git add --all'
    alias gb='git branch'
    alias gba='git branch -a'
    alias gbd='git branch -d'
    alias gc='git commit'
    alias gcm='git commit -m'
    alias gca='git commit -a'
    alias gcam='git commit -a -m'
    alias gco='git checkout'
    alias gcb='git checkout -b'
    alias gd='git diff'
    alias gdc='git diff --cached'
    alias gl='git log --oneline --graph --decorate'
    alias gla='git log --oneline --graph --decorate --all'
    alias gp='git push'
    alias gpl='git pull'
    alias gs='git status'
    alias gst='git stash'
    alias gsta='git stash apply'
    alias gstd='git stash drop'
    alias gstl='git stash list'
    alias gstp='git stash pop'
    alias gsts='git stash show --text'
fi

# Docker aliases (if docker is available)
if command -v docker >/dev/null 2>&1; then
    alias d='docker'
    alias dc='docker compose'
    alias dps='docker ps'
    alias dpsa='docker ps -a'
    alias di='docker images'
    alias drm='docker rm'
    alias drmi='docker rmi'
    alias dex='docker exec -it'
    alias dlogs='docker logs -f'
    alias dstop='docker stop'
    alias dstart='docker start'
    alias drestart='docker restart'
fi

# Systemctl shortcuts
if command -v systemctl >/dev/null 2>&1; then
    alias sc='sudo systemctl'
    alias scs='sudo systemctl status'
    alias sce='sudo systemctl enable'
    alias scd='sudo systemctl disable'
    alias scr='sudo systemctl restart'
    alias sct='sudo systemctl start'
    alias scp='sudo systemctl stop'
    alias scrl='sudo systemctl reload'
    alias jc='journalctl'
    alias jcf='journalctl -f'
    alias jcu='journalctl -u'
fi

# Package manager shortcuts
if command -v pacman >/dev/null 2>&1; then
    alias pac='sudo pacman'
    alias pacs='sudo pacman -S'
    alias pacu='sudo pacman -Syu'
    alias pacr='sudo pacman -R'
    alias pacrs='sudo pacman -Rs'
    alias pacss='pacman -Ss'
    alias pacsi='pacman -Si'
    alias pacsii='pacman -Sii'
    alias pacqi='pacman -Qi'
    alias pacql='pacman -Ql'
    alias pacqs='pacman -Qs'
    alias pacqo='pacman -Qo'
    alias pacqdt='pacman -Qdt'
fi

if command -v yay >/dev/null 2>&1; then
    alias yays='yay -S'
    alias yayu='yay -Syu'
    alias yayss='yay -Ss'
fi

# File compression and extraction
alias tarx='tar -xvf'
alias tarc='tar -cvf'
alias tarz='tar -czvf'
alias tarj='tar -cjvf'
alias untar='tar -xvf'

# Quick edits for common config files
alias zshrc='$EDITOR ~/.config/zsh/zshrc'
alias zshenv='$EDITOR ~/.config/zsh/zshenv'
alias vimrc='$EDITOR ~/.config/nvim/init.lua'
alias bashrc='$EDITOR ~/.bashrc'
alias tmuxconf='$EDITOR ~/.config/tmux/tmux.conf'

# Utilities
alias weather='curl wttr.in'
alias myip='curl -s ifconfig.me && echo'
alias localip="ip route get 1.2.3.4 | awk '{print \$7}'"
alias ports='ss -tuln'
alias mount='mount | column -t'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowdate='date +"%d-%m-%Y"'

# Safety aliases
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Quick navigation to common directories
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias desktop='cd ~/Desktop'
alias projects='cd ~/Projects'
alias workspace='cd ~/Workspace'

# Python aliases
if command -v python3 >/dev/null 2>&1; then
    alias py='python3'
    alias pip='pip3'
    alias venv='python3 -m venv'
    alias serve='python3 -m http.server'
fi

# Node.js aliases
if command -v node >/dev/null 2>&1; then
    alias npmi='npm install'
    alias npms='npm start'
    alias npmt='npm test'
    alias npmr='npm run'
    alias npmu='npm update'
    alias npmg='npm install -g'
fi

# Miscellaneous
alias h='history'
alias j='jobs -l'
alias c='clear'
alias x='exit'
alias q='exit'
alias reload='exec zsh'
alias cls='clear && ls'

# Fun aliases
alias please='sudo'
alias fucking='sudo'
alias matrix='cmatrix'
alias starwars='telnet towel.blinkenlights.nl'

# Create a new function for extracting various archive types
extract() {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Function to create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Function to find and kill process
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [[ -n $pid ]]; then
        echo $pid | xargs kill -${1:-9}
    fi
}

# Function to backup a file
backup() {
    cp "$1"{,.bak}
}

# Function to find files by name
ff() {
    find . -type f -iname "*$1*"
}

# Function to find directories by name
fd() {
    find . -type d -iname "*$1*"
}

# GPG and SSH Agent aliases
alias gpg-restart='restart_gpg_agent'
alias gpg-reload='reload_gpg_agent'
alias gpg-status='gpg-connect-agent "keyinfo --list" /bye'
alias ssh-add-gpg='ssh-add -l'
alias gpg-test='echo "test" | gpg --clearsign'
alias gpg-clean='clean_gpg_cache'

# Zsh cache management
alias zsh-clean-history='rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zsh_history" && echo "Zsh history cache cleaned"'
alias zsh-clean-cache='rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" && echo "Zsh cache directory cleaned"'

# Prompt management
alias prompt-compact='export ZSH_PROMPT_COMPACT=true && echo "Compact prompt mode enabled"'
alias prompt-normal='export ZSH_PROMPT_COMPACT=false && echo "Normal prompt mode enabled"'
alias prompt-toggle='[[ "$ZSH_PROMPT_COMPACT" == "true" ]] && prompt-normal || prompt-compact'
alias prompt-test='echo "Terminal: $TERM | Display: ${DISPLAY:-none} | Wayland: ${WAYLAND_DISPLAY:-none}" && echo "Unicode test: ❯ … vs ASCII: > ..."'
