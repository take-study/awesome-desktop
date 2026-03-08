# Zsh color configuration using global theme variables
# These colors are synchronized with the global theme (tokyonight/onedarkpro)

# Background colors (hex format for terminal)
ZSH_COLOR_BG_PRIMARY="{{bg_primary}}"
ZSH_COLOR_BG_SECONDARY="{{bg_secondary}}"
ZSH_COLOR_BG_TERTIARY="{{bg_tertiary}}"

# Foreground colors
ZSH_COLOR_FG_PRIMARY="{{fg_primary}}"
ZSH_COLOR_FG_SECONDARY="{{fg_secondary}}"
ZSH_COLOR_FG_TERTIARY="{{fg_tertiary}}"

# Accent colors
ZSH_COLOR_BLUE="{{accent_blue}}"
ZSH_COLOR_GREEN="{{accent_green}}"
ZSH_COLOR_RED="{{accent_red}}"
ZSH_COLOR_YELLOW="{{accent_yellow}}"
ZSH_COLOR_ORANGE="{{accent_orange}}"
ZSH_COLOR_PURPLE="{{accent_purple}}"
ZSH_COLOR_CYAN="{{accent_cyan}}"
ZSH_COLOR_MAGENTA="{{accent_magenta}}"

# Semantic colors
ZSH_COLOR_SUCCESS="{{success}}"
ZSH_COLOR_WARNING="{{warning}}"
ZSH_COLOR_ERROR="{{error}}"
ZSH_COLOR_INFO="{{info}}"

# Git colors
ZSH_COLOR_GIT_ADD="{{git_add}}"
ZSH_COLOR_GIT_CHANGE="{{git_change}}"
ZSH_COLOR_GIT_DELETE="{{git_delete}}"

# UI colors
ZSH_COLOR_COMMENT="{{fg_tertiary}}"
ZSH_COLOR_BORDER="{{border_default}}"
ZSH_COLOR_HOVER="{{hover}}"

# Helper function to convert hex color to zsh color code
# This allows using either hex colors or named colors in prompts
hex_to_zsh_color() {
    local hex="$1"
    # Remove # if present
    hex="${hex#\#}"
    echo "%F{#${hex}}"
}

# Prompt color helpers - use these in prompts for consistency
# These return zsh color codes ready to use in PROMPT
prompt_color_blue() { echo "%F{$ZSH_COLOR_BLUE}" }
prompt_color_green() { echo "%F{$ZSH_COLOR_GREEN}" }
prompt_color_red() { echo "%F{$ZSH_COLOR_RED}" }
prompt_color_yellow() { echo "%F{$ZSH_COLOR_YELLOW}" }
prompt_color_orange() { echo "%F{$ZSH_COLOR_ORANGE}" }
prompt_color_purple() { echo "%F{$ZSH_COLOR_PURPLE}" }
prompt_color_cyan() { echo "%F{$ZSH_COLOR_CYAN}" }
prompt_color_magenta() { echo "%F{$ZSH_COLOR_MAGENTA}" }

# Simplified color variables for use in prompts (direct format)
# These can be used directly in PROMPT strings
typeset -g ZSH_PROMPT_COLOR_BLUE="%F{$ZSH_COLOR_BLUE}"
typeset -g ZSH_PROMPT_COLOR_GREEN="%F{$ZSH_COLOR_GREEN}"
typeset -g ZSH_PROMPT_COLOR_RED="%F{$ZSH_COLOR_RED}"
typeset -g ZSH_PROMPT_COLOR_YELLOW="%F{$ZSH_COLOR_YELLOW}"
typeset -g ZSH_PROMPT_COLOR_ORANGE="%F{$ZSH_COLOR_ORANGE}"
typeset -g ZSH_PROMPT_COLOR_PURPLE="%F{$ZSH_COLOR_PURPLE}"
typeset -g ZSH_PROMPT_COLOR_CYAN="%F{$ZSH_COLOR_CYAN}"
typeset -g ZSH_PROMPT_COLOR_MAGENTA="%F{$ZSH_COLOR_MAGENTA}"
typeset -g ZSH_PROMPT_COLOR_RESET="%f"

# Git status colors for prompt
typeset -g ZSH_PROMPT_GIT_ADD="%F{$ZSH_COLOR_GIT_ADD}"
typeset -g ZSH_PROMPT_GIT_CHANGE="%F{$ZSH_COLOR_GIT_CHANGE}"
typeset -g ZSH_PROMPT_GIT_DELETE="%F{$ZSH_COLOR_GIT_DELETE}"

# Syntax highlighting colors (for zsh-syntax-highlighting plugin)
# These will be used in plugins.zsh
typeset -g ZSH_HIGHLIGHT_COLOR_UNKNOWN="$ZSH_COLOR_RED"
typeset -g ZSH_HIGHLIGHT_COLOR_RESERVED="$ZSH_COLOR_CYAN"
typeset -g ZSH_HIGHLIGHT_COLOR_ALIAS="$ZSH_COLOR_GREEN"
typeset -g ZSH_HIGHLIGHT_COLOR_BUILTIN="$ZSH_COLOR_GREEN"
typeset -g ZSH_HIGHLIGHT_COLOR_FUNCTION="$ZSH_COLOR_GREEN"
typeset -g ZSH_HIGHLIGHT_COLOR_COMMAND="$ZSH_COLOR_GREEN"
typeset -g ZSH_HIGHLIGHT_COLOR_PRECOMMAND="$ZSH_COLOR_GREEN"
typeset -g ZSH_HIGHLIGHT_COLOR_SEPARATOR="$ZSH_COLOR_BLUE"
typeset -g ZSH_HIGHLIGHT_COLOR_PATH="default"
typeset -g ZSH_HIGHLIGHT_COLOR_GLOBBING="$ZSH_COLOR_BLUE"
typeset -g ZSH_HIGHLIGHT_COLOR_STRING="$ZSH_COLOR_YELLOW"
typeset -g ZSH_HIGHLIGHT_COLOR_REDIRECTION="$ZSH_COLOR_BLUE"
typeset -g ZSH_HIGHLIGHT_COLOR_COMMENT="$ZSH_COLOR_COMMENT"
typeset -g ZSH_HIGHLIGHT_COLOR_BRACKET_1="$ZSH_COLOR_BLUE"
typeset -g ZSH_HIGHLIGHT_COLOR_BRACKET_2="$ZSH_COLOR_GREEN"
typeset -g ZSH_HIGHLIGHT_COLOR_BRACKET_3="$ZSH_COLOR_MAGENTA"

# Autosuggestion color (for zsh-autosuggestions plugin)
typeset -g ZSH_AUTOSUGGEST_COLOR="$ZSH_COLOR_FG_TERTIARY"

