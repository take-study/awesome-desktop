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

# Make sudo work for alas
alias sudo='sudo '


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

# Miscellaneous
alias h='history'
alias j='jobs -l'
alias c='clear'
alias x='exit'
alias q='exit'
alias reload='exec zsh'
alias cls='clear && ls'

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

# Z-like directory jumping functionality
# Initialize directory history file
Z_DATA="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/z_dirs"
[[ ! -d "$(dirname "$Z_DATA")" ]] && mkdir -p "$(dirname "$Z_DATA")"
[[ ! -f "$Z_DATA" ]] && touch "$Z_DATA"

# Function to add current directory to z database
_z_add() {
    local dir="$PWD"
    [[ "$dir" == "$HOME" ]] && return
    
    # Remove existing entry and add to top with timestamp
    local temp_file="${Z_DATA}.tmp"
    grep -v "^$dir|" "$Z_DATA" > "$temp_file" 2>/dev/null || true
    echo "$dir|$(date +%s)|1" >> "$temp_file"
    
    # Keep only last 100 entries
    tail -100 "$temp_file" > "$Z_DATA"
    rm "$temp_file"
}

# Main z function for directory jumping
z() {
    if [[ $# -eq 0 ]]; then
        # Show recent directories
        echo "Recent directories:"
        awk -F'|' '{print NR ": " $1}' "$Z_DATA" | tail -10
        return
    fi
    
    local pattern="$1"
    local matches
    
    # Find matching directories (case insensitive)
    matches=$(grep -i "$pattern" "$Z_DATA" | awk -F'|' '{print $1}' | tac)
    
    if [[ -z "$matches" ]]; then
        echo "No matches found for: $pattern"
        return 1
    fi
    
    # Get first match that exists
    local target
    while IFS= read -r dir; do
        if [[ -d "$dir" ]]; then
            target="$dir"
            break
        fi
    done <<< "$matches"
    
    if [[ -n "$target" ]]; then
        cd "$target"
        echo "Jumped to: $target"
    else
        echo "No valid directories found for: $pattern"
        return 1
    fi
}

# Hook to add directories automatically
autoload -U add-zsh-hook
add-zsh-hook chpwd _z_add

# Z aliases and related functions
alias zz='z'                                    # Short alias for z
alias zi='z'                                    # Alternative alias
alias zh='cat "$Z_DATA" | awk -F"|" "{print \$1}" | tail -20'  # Show z history
alias zc='> "$Z_DATA" && echo "Z history cleared"'  # Clear z history
alias ze='$EDITOR "$Z_DATA"'                    # Edit z database

{{#if (eq usegnupg "1")}}
# GPG and SSH Agent aliases
alias gpg-restart='restart_gpg_agent'
alias gpg-reload='reload_gpg_agent'
alias gpg-status='gpg-connect-agent "keyinfo --list" /bye'
alias ssh-add-gpg='ssh-add -l'
alias gpg-test='echo "test" | gpg --clearsign'
alias gpg-clean='clean_gpg_cache'
{{/if}}

# Zsh cache management
alias zsh-clean-history='rm -f "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zsh_history" && echo "Zsh history cache cleaned"'
alias zsh-clean-cache='rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" && echo "Zsh cache directory cleaned"'

# Prompt management
alias prompt-compact='export ZSH_PROMPT_COMPACT=true && echo "Compact prompt mode enabled"'
alias prompt-normal='export ZSH_PROMPT_COMPACT=false && echo "Normal prompt mode enabled"'
alias prompt-toggle='[[ "$ZSH_PROMPT_COMPACT" == "true" ]] && prompt-normal || prompt-compact'
alias prompt-test='echo "Terminal: $TERM | Display: ${DISPLAY:-none} | Wayland: ${WAYLAND_DISPLAY:-none}" && echo "Unicode test: ❯ … vs ASCII: > ..."'
