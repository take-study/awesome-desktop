# Zsh Plugins Configuration
# Plugin directory
ZSH_PLUGINS_DIR="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}/plugins"

# Source zsh-completions if available
if [[ -d "$ZSH_PLUGINS_DIR/zsh-completions" ]]; then
    fpath=($ZSH_PLUGINS_DIR/zsh-completions/src $fpath)
fi

# Initialize completion system
autoload -Uz compinit
# Check for cache daily
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
    compinit
else
    compinit -C
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

# Source zsh-autosuggestions if available
if [[ -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
    # Autosuggestion settings
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
    ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    
    # Key bindings for autosuggestions
    bindkey '^[[C' forward-char                    # Right arrow key
    bindkey '^F' autosuggest-accept                # Ctrl+F to accept suggestion
    bindkey '^]' autosuggest-execute               # Ctrl+] to accept and execute
fi

# Source zsh-syntax-highlighting (must be last)
if [[ -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
    source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    
    # Syntax highlighting settings
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
    ZSH_HIGHLIGHT_STYLES[global-alias]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=green,underline'
    ZSH_HIGHLIGHT_STYLES[path]='fg=blue,underline'
    ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=blue'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[command-substitution]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=red'
    ZSH_HIGHLIGHT_STYLES[process-substitution]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=red'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=green'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=green'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=red'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[redirection]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
    ZSH_HIGHLIGHT_STYLES[named-fd]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'
    ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-1]='fg=blue,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-2]='fg=green,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-3]='fg=magenta,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-4]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[bracket-level-5]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]='standout'
fi
