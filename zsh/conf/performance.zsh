# Zsh Performance Optimizations
# Additional performance tweaks and lazy loading functions

# Disable unnecessary features for better performance
unsetopt BEEP                    # Disable terminal bell
unsetopt FLOW_CONTROL           # Disable flow control (Ctrl+S/Ctrl+Q)

# Optimize word characters for faster word navigation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Lazy load function - only load when first command is typed
first_command_hook() {
    # Remove this hook after first run
    unfunction first_command_hook
    add-zsh-hook -d preexec first_command_hook
}

# Add hook for first command
autoload -Uz add-zsh-hook
add-zsh-hook preexec first_command_hook

# Function to compile zsh configuration files for faster loading (manual)
compile_zsh_configs() {
    local config_dir="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}"
    
    echo "Compiling zsh configuration files..."
    
    # Compile main configuration files
    for file in "$config_dir"/{zshrc,zshenv} "$config_dir"/conf/*.zsh; do
        if [[ -f "$file" && ! -f "${file}.zwc" ]] || [[ "$file" -nt "${file}.zwc" ]]; then
            echo "Compiling: $file"
            zcompile "$file" 2>/dev/null || true
        fi
    done
    
    # Compile plugin files
    local plugin_dir="$config_dir/plugins"
    if [[ -d "$plugin_dir" ]]; then
        for plugin in "$plugin_dir"/*/*.zsh; do
            if [[ -f "$plugin" && ! -f "${plugin}.zwc" ]] || [[ "$plugin" -nt "${plugin}.zwc" ]]; then
                echo "Compiling: $plugin"
                zcompile "$plugin" 2>/dev/null || true
            fi
        done
    fi
    
    # Compile completion dump
    local zcompdump="$XDG_CACHE_HOME/zsh/zcompdump"
    if [[ -f "$zcompdump" && ! -f "${zcompdump}.zwc" ]] || [[ "$zcompdump" -nt "${zcompdump}.zwc" ]]; then
        echo "Compiling: $zcompdump"
        zcompile "$zcompdump" 2>/dev/null || true
    fi
    
    echo "Zsh configuration compilation complete!"
}

# Optimization aliases
alias zsh-bench='for i in {1..10}; do time zsh -i -c exit; done'
alias zsh-compile='compile_zsh_configs'
alias zsh-clean='rm -f ~/.zcompdump* ~/.zsh_history.* ~/.config/zsh/**/*.zwc && echo "Zsh compiled files cleaned"'
alias zsh-force-compile='rm -f ~/.config/zsh/**/*.zwc && compile_zsh_configs'

# Performance monitoring
zsh_startup_time() {
    local total=0
    local iterations=${1:-5}
    
    echo "Running $iterations zsh startup tests..."
    for i in {1..$iterations}; do
        local time_output=$(time zsh -i -c exit 2>&1)
        local real_time=$(echo "$time_output" | grep real | awk '{print $2}' | sed 's/[^0-9.]//g')
        total=$(echo "$total + $real_time" | bc 2>/dev/null || echo "$total")
        echo "Test $i: ${real_time}s"
    done
    
    if command -v bc >/dev/null 2>&1; then
        local average=$(echo "scale=3; $total / $iterations" | bc)
        echo "Average startup time: ${average}s"
    fi
}
