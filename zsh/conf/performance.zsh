# Zsh Performance Optimizations
# Additional performance tweaks and lazy loading functions

# Disable unnecessary features for better performance
unsetopt BEEP                    # Disable terminal bell
unsetopt FLOW_CONTROL           # Disable flow control (Ctrl+S/Ctrl+Q)

# Optimize word characters for faster word navigation
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Lazy load heavy completions
lazy_load_completions() {
    # Only load docker completions when docker is used
    if command -v docker >/dev/null 2>&1; then
        if [[ ! -f ~/.zcompdump.docker ]]; then
            # Generate docker completions only once
            docker completion zsh > ~/.zcompdump.docker 2>/dev/null || true
        fi
        [[ -f ~/.zcompdump.docker ]] && source ~/.zcompdump.docker
    fi
    
    # Similar pattern for other heavy completions
    if command -v kubectl >/dev/null 2>&1; then
        if [[ ! -f ~/.zcompdump.kubectl ]]; then
            kubectl completion zsh > ~/.zcompdump.kubectl 2>/dev/null || true
        fi
        [[ -f ~/.zcompdump.kubectl ]] && source ~/.zcompdump.kubectl
    fi
}

# Lazy load function - only load when first command is typed
first_command_hook() {
    # Remove this hook after first run
    unfunction first_command_hook
    add-zsh-hook -d preexec first_command_hook
    
    # Load heavy completions in background
    lazy_load_completions &!
}

# Add hook for first command
autoload -Uz add-zsh-hook
add-zsh-hook preexec first_command_hook

# Function to compile zsh configuration files for faster loading
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
    
    echo "Zsh configuration compilation complete!"
}

# Auto-compile on configuration changes
auto_compile_configs() {
    local config_dir="${ZSH_CONFIG_DIR:-$HOME/.config/zsh}"
    
    # Check if any config file is newer than its compiled version
    for file in "$config_dir"/{zshrc,zshenv} "$config_dir"/conf/*.zsh; do
        if [[ -f "$file" && ! -f "${file}.zwc" ]] || [[ "$file" -nt "${file}.zwc" ]]; then
            compile_zsh_configs
            break
        fi
    done
}

# Run auto-compile check in background (non-blocking)
auto_compile_configs &!

# Optimization aliases
alias zsh-bench='for i in {1..10}; do time zsh -i -c exit; done'
alias zsh-compile='compile_zsh_configs'
alias zsh-clean='rm -f ~/.zcompdump* ~/.zsh_history.* ~/.config/zsh/**/*.zwc'

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
