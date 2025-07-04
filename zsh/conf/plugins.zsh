# Zsh Plugins Configuration
# Plugin directory
ZSH_PLUGINS_DIR="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}/plugins"

# Source zsh-completions if available
if [[ -d "$ZSH_PLUGINS_DIR/zsh-completions" ]]; then
    fpath=($ZSH_PLUGINS_DIR/zsh-completions/src $fpath)
fi

# Initialize completion system with optimized caching
autoload -Uz compinit
# Cache completion dump and only rebuild when necessary
local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
if [[ -f "$zcompdump" && "$zcompdump" -nt ~/.zshrc ]]; then
    # Load cached completions without security check for speed
    compinit -C -d "$zcompdump"
else
    # Full initialization only when needed
    compinit -d "$zcompdump"
    # Compile the completion dump for faster loading
    [[ -f "$zcompdump" && ! -f "${zcompdump}.zwc" ]] && zcompile "$zcompdump"
fi

# Completion settings
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:default' menu 'select=0'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.*' insert-tab true
zstyle ':completion:*' verbose true

# Source zsh-autosuggestions if available (optimized)
if [[ -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    
    # Optimized autosuggestion settings for performance
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Use history first, then completion for suggestions
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_MANUAL_REBIND=1     # Manual rebind for better performance
    ZSH_AUTOSUGGEST_HISTORY_IGNORE="?(#c50,)"  # Ignore very long commands
    
    # Optimized key bindings
    bindkey '^[[C' forward-char         # Right arrow key
    bindkey '^F' autosuggest-accept     # Ctrl+F to accept suggestion
    bindkey '^]' autosuggest-execute    # Ctrl+] to accept and execute
fi

# Source zsh-syntax-highlighting (must be last)
if [[ -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    
    # Optimized syntax highlighting with essential styles only
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
    
    # Essential highlighting styles (reduced set for performance)
    typeset -A ZSH_HIGHLIGHT_STYLES=(
        [unknown-token]='fg=red,bold'
        [reserved-word]='fg=cyan,bold'
        [alias]='fg=green'
        [builtin]='fg=green'
        [function]='fg=green'
        [command]='fg=green'
        [precommand]='fg=green,underline'
        [commandseparator]='fg=blue,bold'
        [path]='underline'
        [globbing]='fg=blue'
        [single-quoted-argument]='fg=yellow'
        [double-quoted-argument]='fg=yellow'
        [redirection]='fg=blue,bold'
        [comment]='fg=black,bold'
        [bracket-level-1]='fg=blue,bold'
        [bracket-level-2]='fg=green,bold'
        [bracket-level-3]='fg=magenta,bold'
    )
fi
