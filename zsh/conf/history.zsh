# Zsh History Configuration

# History file location and size - use cache directory
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"
HISTFILE="${ZSH_CACHE_DIR}/zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt EXTENDED_HISTORY          # Save timestamp and duration
setopt SHARE_HISTORY            # Share history between sessions
setopt APPEND_HISTORY           # Append to history file
setopt INC_APPEND_HISTORY       # Write to history file immediately
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicates first when trimming history
setopt HIST_IGNORE_DUPS         # Don't record duplicate consecutive commands
setopt HIST_IGNORE_ALL_DUPS     # Remove older duplicate commands
setopt HIST_FIND_NO_DUPS        # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE        # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS        # Don't save duplicates to history file
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording
setopt HIST_VERIFY             # Show command with history expansion before running

# Don't save certain commands to history
HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|clear|reset)"

# Function to clean history
clean_history() {
    local temp_file=$(mktemp)
    awk '!seen[$0]++' "$HISTFILE" > "$temp_file" && mv "$temp_file" "$HISTFILE"
    echo "History cleaned: duplicates removed"
}

# Function to search history with fzf (if available)
if command -v fzf >/dev/null 2>&1; then
    fzf_history() {
        local selected_command
        selected_command=$(fc -rl 1 | awk '{$1=""; print substr($0,2)}' | fzf --height=40% --reverse --query="$LBUFFER")
        if [[ -n $selected_command ]]; then
            BUFFER=$selected_command
            CURSOR=$#BUFFER
        fi
        zle redisplay
    }
    zle -N fzf_history
    bindkey '^R' fzf_history
fi

