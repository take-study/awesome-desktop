use std/util "path add"
path add ($env.HOME | path join ".local/bin")
path add ($env.HOME | path join ".cargo/bin")

$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config")
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share")
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache")
$env.XDG_STATE_HOME = ($env.HOME | path join ".local/state")

{{#if (eq usegnupg "1")}}
# GPG configuration
$env.GPG_TTY = $env.tty
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket 2>/dev/null)
{{/if}}
