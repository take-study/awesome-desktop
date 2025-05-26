# Zsh Key Bindings Configuration

# Set vi mode as default (can be changed to emacs with toggle function)
bindkey -v

# Reduce key timeout for faster mode switching
export KEYTIMEOUT=1

# Vi mode key bindings for insert mode
bindkey -M viins '^[[A' history-search-backward  # Up arrow
bindkey -M viins '^[[B' history-search-forward   # Down arrow
bindkey -M viins '^P' history-search-backward    # Ctrl+P
bindkey -M viins '^N' history-search-forward     # Ctrl+N
bindkey -M viins '^A' beginning-of-line          # Ctrl+A
bindkey -M viins '^E' end-of-line                # Ctrl+E
bindkey -M viins '^K' kill-line                  # Ctrl+K
bindkey -M viins '^U' kill-whole-line            # Ctrl+U
bindkey -M viins '^W' backward-kill-word         # Ctrl+W
bindkey -M viins '^Y' yank                       # Ctrl+Y
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward

# Vi mode key bindings for command mode
bindkey -M vicmd 'k' history-search-backward
bindkey -M vicmd 'j' history-search-forward
bindkey -M vicmd '/' history-incremental-search-backward
bindkey -M vicmd '?' history-incremental-search-forward

# Additional vi-style bindings
bindkey -M vicmd 'H' beginning-of-line
bindkey -M vicmd 'L' end-of-line
bindkey -M vicmd 'gg' beginning-of-buffer-or-history
bindkey -M vicmd 'G' end-of-buffer-or-history

# Word movement (both modes)
bindkey -M viins '^[[1;5C' forward-word         # Ctrl+Right
bindkey -M viins '^[[1;5D' backward-word        # Ctrl+Left
bindkey -M viins '^[[1;3C' forward-word         # Alt+Right  
bindkey -M viins '^[[1;3D' backward-word        # Alt+Left
bindkey -M viins '^F' forward-word               # Ctrl+F
bindkey -M viins '^B' backward-word              # Ctrl+B

# Function to toggle between vi and emacs mode
toggle-keymap() {
    if [[ $KEYMAP == "vicmd" ]] || [[ $ZLE_STATE == *vicmd* ]]; then
        bindkey -e
        zle -M "Switched to Emacs mode"
    else
        bindkey -v
        zle -M "Switched to Vi mode" 
    fi
}
zle -N toggle-keymap
bindkey -M viins '^[^[' toggle-keymap  # Alt+Esc to toggle
bindkey -M vicmd '^[^[' toggle-keymap  # Alt+Esc to toggle

# Delete keys (both modes)
bindkey -M viins '^[[3~' delete-char             # Delete key
bindkey -M viins '^H' backward-delete-char       # Backspace
bindkey -M viins '^?' backward-delete-char       # Backspace (alternative)

# Home and End keys (both modes)
bindkey -M viins '^[[H' beginning-of-line       # Home
bindkey -M viins '^[[F' end-of-line             # End
bindkey -M viins '^[[1~' beginning-of-line      # Home (alternative)
bindkey -M viins '^[[4~' end-of-line            # End (alternative)
bindkey -M vicmd '^[[H' beginning-of-line       # Home
bindkey -M vicmd '^[[F' end-of-line             # End

# Page Up/Down for history search (both modes)
bindkey -M viins '^[[5~' history-beginning-search-backward  # Page Up
bindkey -M viins '^[[6~' history-beginning-search-forward   # Page Down
bindkey -M vicmd '^[[5~' history-beginning-search-backward  # Page Up
bindkey -M vicmd '^[[6~' history-beginning-search-forward   # Page Down

# Alt+. to insert last argument (insert mode)
bindkey -M viins '^[.' insert-last-word

# Ctrl+X Ctrl+E to edit command line in editor (both modes)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M viins '^X^E' edit-command-line
bindkey -M vicmd '^X^E' edit-command-line
# In vi command mode, also allow 'v' to edit line
bindkey -M vicmd 'v' edit-command-line

# Custom key bindings for enhanced functionality
# Ctrl+L to clear screen (preserve in history) - both modes
clear-screen-and-scrollback() {
    echoti civis >"$TTY"
    printf '%s' '' >"$TTY"
    zle clear-screen
    echoti cnorm >"$TTY"
}
zle -N clear-screen-and-scrollback
bindkey -M viins '^L' clear-screen-and-scrollback
bindkey -M vicmd '^L' clear-screen-and-scrollback

# Alt+H for help with current command (both modes)
unalias run-help 2>/dev/null
run-help() {
    if [[ $# -eq 0 ]]; then
        BUFFER="man"
        zle accept-line
    else
        man "$@"
    fi
}
autoload -Uz run-help
alias help=run-help
bindkey -M viins '^[h' run-help
bindkey -M vicmd '^[h' run-help

# Ctrl+Q to push current line to buffer and restore after next command (both modes)
bindkey -M viins '^Q' push-line-or-edit
bindkey -M vicmd '^Q' push-line-or-edit

# History expansion (insert mode)
bindkey -M viins ' ' magic-space                # Space expands history
bindkey -M viins '^I' expand-or-complete-prefix # Tab completion

# Custom widgets for better experience
# Smart cd that can navigate to directories from anywhere
smart-cd() {
    if [[ -d "$BUFFER" ]]; then
        BUFFER="cd $BUFFER"
        zle accept-line
    else
        zle self-insert
    fi
}
zle -N smart-cd
bindkey '^[/' smart-cd

# Quick sudo
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        BUFFER="${BUFFER#sudo }"
    else
        BUFFER="sudo $BUFFER"
    fi
    zle end-of-line
}
zle -N sudo-command-line
bindkey '^[s' sudo-command-line

# Copy current command to clipboard (requires xclip or pbcopy)
copy-command() {
    if command -v xclip >/dev/null 2>&1; then
        echo -n "$BUFFER" | xclip -selection clipboard
    elif command -v pbcopy >/dev/null 2>&1; then
        echo -n "$BUFFER" | pbcopy
    elif command -v wl-copy >/dev/null 2>&1; then
        echo -n "$BUFFER" | wl-copy
    fi
    zle -M "Command copied to clipboard"
}
zle -N copy-command
bindkey '^[c' copy-command
