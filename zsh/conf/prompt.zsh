# Simple and Clean Zsh Prompt
setopt PROMPT_SUBST

# Load git info
autoload -Uz vcs_info

# Configure git info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:*' unstagedstr '%F{red}!%f'
zstyle ':vcs_info:git:*' formats ' %F{cyan}%b%f%c%u%m'
zstyle ':vcs_info:git:*' actionformats ' %F{cyan}%b|%a%f%c%u%m'

# Simple and Clean Zsh Prompt with Performance Optimizations
setopt PROMPT_SUBST

# Load git info
autoload -Uz vcs_info

# Configure git info with optimized settings
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green}+%f'
zstyle ':vcs_info:*' unstagedstr '%F{red}!%f'
zstyle ':vcs_info:git:*' formats ' %F{cyan}%b%f%c%u%m'
zstyle ':vcs_info:git:*' actionformats ' %F{cyan}%b|%a%f%c%u%m'

# Cache variables for git information
typeset -g _git_cache_dir=""
typeset -g _git_cache_info=""
typeset -g _git_cache_counts=""
typeset -g _git_cache_time=0

# Function to get git change counts with caching
git_change_counts() {
    local current_dir="$PWD"
    local current_time="$EPOCHSECONDS"
    
    # Check if we're in the same git repo and cache is fresh (within 5 seconds)
    if [[ "$_git_cache_dir" == "$current_dir" && $(( current_time - _git_cache_time )) -lt 5 ]]; then
        echo "$_git_cache_counts"
        return
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        _git_cache_dir=""
        _git_cache_counts=""
        return
    fi
    
    # Update cache
    _git_cache_dir="$current_dir"
    _git_cache_time="$current_time"
    
    # Use git status porcelain for efficient change detection
    local git_status
    git_status=$(git status --porcelain 2>/dev/null) || {
        _git_cache_counts=""
        echo ""
        return
    }
    
    local staged=0 unstaged=0 untracked=0
    
    # Parse git status output efficiently
    while IFS= read -r line; do
        case "${line:0:2}" in
            "??") ((untracked++)) ;;
            ?M|?D|?T) ((unstaged++)) ;;
            M?|A?|D?|R?|C?|T?) ((staged++)) ;;
            MM|MD|AM|AD) ((staged++)); ((unstaged++)) ;;
        esac
    done <<< "$git_status"
    
    local counts=""
    [[ $staged -gt 0 ]] && counts+=" %F{green}+$staged%f"
    [[ $unstaged -gt 0 ]] && counts+=" %F{red}~$unstaged%f"  
    [[ $untracked -gt 0 ]] && counts+=" %F{yellow}?$untracked%f"
    
    _git_cache_counts="$counts"
    echo "$counts"
}

# Function to display path with smart truncation (optimized)
colored_path() {
    local current_path="$PWD"
    local max_length=40
    local max_dirs=3
    
    # Check for compact mode
    if [[ "$ZSH_PROMPT_COMPACT" == "true" ]]; then
        max_length=25
        max_dirs=2
    fi
    
    # Replace home with ~ (using parameter expansion for speed)
    current_path="${current_path/#$HOME/~}"
    
    # If path is short enough, show it as is
    if [[ ${#current_path} -le $max_length ]]; then
        echo "%F{blue}$current_path%f"
        return
    fi
    
    # Determine ellipsis character (cached check)
    local ellipsis="…"
    if [[ -z "$DISPLAY$WAYLAND_DISPLAY" ]] || [[ "$TERM" == @(linux|vt100|vt220|dumb) ]]; then
        ellipsis="..."
    fi
    
    # Split path using zsh arrays (faster than IFS)
    local -a path_parts=(${(s:/:)current_path})
    
    # If we have too many components, truncate from the beginning
    if [[ ${#path_parts} -gt $max_dirs ]]; then
        local truncated_path=""
        local start_index=$((${#path_parts} - $max_dirs + 1))
        
        # Handle root vs home paths
        if [[ "$current_path" == "~"* ]]; then
            truncated_path="~/$ellipsis/"
        else
            truncated_path="/$ellipsis/"
        fi
        
        # Add the last few components
        truncated_path+="${(j:/:)path_parts[$start_index,-1]}"
        echo "%F{blue}$truncated_path%f"
    else
        # Simple truncation for fewer components
        local max_component=15
        local -a truncated_parts=()
        
        for part in "${path_parts[@]}"; do
            if [[ -n "$part" && ${#part} -gt $max_component ]]; then
                truncated_parts+=("${part:0:$((max_component-${#ellipsis}))}$ellipsis")
            else
                truncated_parts+=("$part")
            fi
        done
        
        echo "%F{blue}${(j:/:)truncated_parts}%f"
    fi
}

# Function to get vi mode indicator (optimized with static detection)
vi_mode_indicator() {
    # Static unicode detection (only check once)
    if [[ -z "$_prompt_unicode_support" ]]; then
        if [[ -n "$DISPLAY$WAYLAND_DISPLAY" ]] && [[ "$TERM" != @(linux|vt100|vt220|screen|dumb) ]]; then
            _prompt_unicode_support=1
        else
            _prompt_unicode_support=0
        fi
    fi
    
    # Use appropriate symbols
    if [[ "$_prompt_unicode_support" -eq 1 ]]; then
        case ${KEYMAP:-main} in
            vicmd) echo "%F{red}❯%f";;
            *) echo "%F{green}❯%f";;
        esac
    else
        case ${KEYMAP:-main} in
            vicmd) echo "%F{red}>%f";;
            *) echo "%F{green}>%f";;
        esac
    fi
}

# Optimized precmd with reduced git calls
precmd() {
    # Only update vcs_info if we're in a git repository
    if git rev-parse --git-dir >/dev/null 2>&1; then
        vcs_info
        vcs_info_msg_0_+="$(git_change_counts)"
    else
        vcs_info_msg_0_=""
    fi
}

# Optimized vi mode keymap handler
function zle-keymap-select {
    # Update cursor shape only if in supported terminal
    if [[ "$TERM" != @(linux|vt100|vt220|dumb) ]]; then
        case $KEYMAP in
            vicmd) echo -ne '\e[1 q';;      # block cursor
            *) echo -ne '\e[5 q';;          # beam cursor
        esac
    fi
    zle reset-prompt
}
zle -N zle-keymap-select

# Initialize with insert mode cursor (optimized)
function zle-line-init {
    [[ "$TERM" != @(linux|vt100|vt220|dumb) ]] && echo -ne '\e[5 q'
    zle reset-prompt
}
zle -N zle-line-init

# Final prompt configuration
PROMPT='$(colored_path)${vcs_info_msg_0_} $(vi_mode_indicator) '

# Continuation prompt (with static unicode detection)
if [[ -z "$DISPLAY$WAYLAND_DISPLAY" ]] || [[ "$TERM" == @(linux|vt100|vt220|dumb) ]]; then
    PROMPT2='%F{yellow}>%f '
else
    PROMPT2='%F{yellow}❯%f '
fi

# Global variables for caching
typeset -g _prompt_unicode_support

# Prompt customization options:
# - Set ZSH_PROMPT_COMPACT=true for even more compact paths
# - Use aliases: prompt-compact, prompt-normal, prompt-toggle
# 
# Path truncation behavior:
# - Normal mode: max 40 chars, shows last 3 dirs (~/.../)
# - Compact mode: max 25 chars, shows last 2 dirs  
# - Long directory names are truncated with … symbol (or ... in basic terminals)
# - Always shows ~ for home directory
#
# Terminal compatibility:
# - Automatically detects GUI vs non-GUI environments
# - Uses Unicode symbols (❯, …) in modern terminals
# - Falls back to ASCII symbols (>, ...) in basic terminals
# - Compatible with Linux console, SSH sessions, and TTY
