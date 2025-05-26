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

# Function to get git change counts
git_change_counts() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        local staged=$(git diff --cached --name-only | wc -l)
        local unstaged=$(git diff --name-only | wc -l)
        local untracked=$(git ls-files --others --exclude-standard | wc -l)
        
        local counts=""
        [[ $staged -gt 0 ]] && counts+=" %F{green}+$staged%f"
        [[ $unstaged -gt 0 ]] && counts+=" %F{red}~$unstaged%f"
        [[ $untracked -gt 0 ]] && counts+=" %F{yellow}?$untracked%f"
        
        echo "$counts"
    fi
}

# Function to display path with smart truncation
colored_path() {
    local current_path="$PWD"
    local home_path="$HOME"
    local max_length=40  # Maximum path length before truncation
    local max_dirs=3     # Maximum number of directory components to show
    
    # Check for compact mode
    if [[ "$ZSH_PROMPT_COMPACT" == "true" ]]; then
        max_length=25
        max_dirs=2
    fi
    
    # Determine ellipsis character based on terminal capabilities
    local ellipsis="…"
    if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$TERM" != *"256color"* ]] || \
       [[ "$TERM" == "linux" || "$TERM" == "vt100" || "$TERM" == "vt220" || "$TERM" == "dumb" ]]; then
        ellipsis="..."
    fi
    
    # Replace home with ~
    if [[ "$current_path" == "$home_path"* ]]; then
        current_path="~${current_path#$home_path}"
    fi
    
    # If path is short enough, show it as is
    if [[ ${#current_path} -le $max_length ]]; then
        echo "%F{blue}$current_path%f"
        return
    fi
    
    # Split path into components
    local -a path_parts
    IFS='/' read -A path_parts <<< "$current_path"
    
    # If we have too many components, truncate from the beginning
    if [[ ${#path_parts} -gt $max_dirs ]]; then
        local truncated_path=""
        local start_index=$((${#path_parts} - $max_dirs + 1))
        
        # Add ellipsis for truncated parts
        if [[ "${path_parts[1]}" == "~" ]]; then
            truncated_path="~/"
            start_index=$((start_index + 1))
        else
            truncated_path="/"
        fi
        truncated_path+="$ellipsis/"
        
        # Add the last few components
        for i in {$start_index..${#path_parts}}; do
            if [[ -n "${path_parts[i]}" ]]; then
                truncated_path+="${path_parts[i]}"
                if [[ $i -lt ${#path_parts} ]]; then
                    truncated_path+="/"
                fi
            fi
        done
        
        echo "%F{blue}$truncated_path%f"
    else
        # Path has few components but is long, truncate individual components
        local truncated_path=""
        local max_component_length=15
        
        for i in {1..${#path_parts}}; do
            local component="${path_parts[i]}"
            
            # Skip empty components (from leading /)
            if [[ -z "$component" ]]; then
                continue
            fi
            
            # Truncate long components
            if [[ ${#component} -gt $max_component_length ]]; then
                component="${component:0:$((max_component_length-${#ellipsis}))}$ellipsis"
            fi
            
            if [[ -n "$truncated_path" && "$truncated_path" != "/" && "$truncated_path" != "~" ]]; then
                truncated_path+="/"
            fi
            truncated_path+="$component"
        done
        
        echo "%F{blue}$truncated_path%f"
    fi
}

# Function to get vi mode indicator with fallback for non-GUI environments
vi_mode_indicator() {
    # Check if we're in a graphical environment or have unicode support
    local use_unicode=true
    
    # Detect non-graphical environments
    if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$TERM" != *"256color"* ]]; then
        use_unicode=false
    fi
    
    # Check for common non-unicode terminals
    case "$TERM" in
        linux|vt100|vt220|screen|dumb)
            use_unicode=false
            ;;
    esac
    
    # Use appropriate symbols based on environment
    if [[ "$use_unicode" == "true" ]]; then
        # Unicode arrows for modern terminals
        case ${KEYMAP:-main} in
            vicmd) echo "%F{red}❯%f";;      # Normal mode: red arrow
            viins|main) echo "%F{green}❯%f";; # Insert mode: green arrow
            *) echo "%F{green}❯%f";;        # Default: green arrow
        esac
    else
        # ASCII fallback for basic terminals
        case ${KEYMAP:-main} in
            vicmd) echo "%F{red}>%f";;       # Normal mode: red >
            viins|main) echo "%F{green}>%f";; # Insert mode: green >
            *) echo "%F{green}>%f";;         # Default: green >
        esac
    fi
}

# Update git info before each prompt
precmd() {
    vcs_info
    # Add git change counts to vcs_info
    if git rev-parse --git-dir > /dev/null 2>&1; then
        vcs_info_msg_0_+="$(git_change_counts)"
    fi
}

# Vi mode keymap change handler
function zle-keymap-select {
    # Update cursor shape
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block cursor for normal mode
        viins|main) echo -ne '\e[5 q';; # beam cursor for insert mode
    esac
    # Redraw prompt to update mode indicator
    zle reset-prompt
}
zle -N zle-keymap-select

# Initialize with insert mode cursor
function zle-line-init {
    echo -ne '\e[5 q'
    # Redraw prompt
    zle reset-prompt
}
zle -N zle-line-init

# Prompt with colored path, git info, and vi mode indicator
PROMPT='$(colored_path)${vcs_info_msg_0_} $(vi_mode_indicator) '

# Continuation prompt for multi-line commands (with fallback)
if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$TERM" != *"256color"* ]] || \
   [[ "$TERM" == "linux" || "$TERM" == "vt100" || "$TERM" == "vt220" || "$TERM" == "dumb" ]]; then
    PROMPT2='%F{yellow}>%f '  # ASCII fallback
else
    PROMPT2='%F{yellow}❯%f '  # Unicode arrow
fi

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
