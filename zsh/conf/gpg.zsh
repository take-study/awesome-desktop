# GPG Agent and SSH Agent configuration
# Configure gpg-agent to act as ssh-agent

# Ensure cache directory exists for temporary files
GPG_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/gpg"
mkdir -p "$GPG_CACHE_DIR"

# Start GPG agent if not already running
if ! pgrep -x "gpg-agent" > /dev/null; then
    # Start gpg-agent with SSH support, write env file to cache
    gpg-agent --daemon --enable-ssh-support --write-env-file "${GPG_CACHE_DIR}/gpg-agent-info" > /dev/null 2>&1
fi

# Set up environment for gpg-agent as ssh-agent
if [ -f "${GPG_CACHE_DIR}/gpg-agent-info" ]; then
    source "${GPG_CACHE_DIR}/gpg-agent-info"
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
    export SSH_AGENT_PID
fi

# Alternative method: Use gpgconf to get socket path
if command -v gpgconf >/dev/null 2>&1; then
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Set GPG TTY for proper terminal interaction
export GPG_TTY=$(tty)

# Refresh gpg-agent tty and update terminal
gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1

# Function to reload gpg-agent
reload_gpg_agent() {
    echo "Reloading GPG agent..."
    gpg-connect-agent reloadagent /bye
    echo "GPG agent reloaded."
}

# Function to kill and restart gpg-agent
restart_gpg_agent() {
    echo "Restarting GPG agent..."
    gpgconf --kill gpg-agent
    # Use cache directory for temporary env file
    gpg-agent --daemon --enable-ssh-support --write-env-file "${GPG_CACHE_DIR}/gpg-agent-info" > /dev/null 2>&1
    source "${GPG_CACHE_DIR}/gpg-agent-info" 2>/dev/null
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    export GPG_TTY=$(tty)
    echo "GPG agent restarted."
}

# Function to clean up temporary GPG files
clean_gpg_cache() {
    echo "Cleaning GPG cache..."
    if [ -d "$GPG_CACHE_DIR" ]; then
        rm -f "${GPG_CACHE_DIR}/gpg-agent-info"
        echo "GPG cache cleaned."
    else
        echo "GPG cache directory does not exist."
    fi
}
