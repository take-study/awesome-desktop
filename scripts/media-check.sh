#!/bin/bash

# Media detection script for hypridle (optimized)
# Checks if any media is currently playing and prevents suspend/lock if so

# Cache command availability to avoid repeated checks
declare -A CMD_CACHE

cmd_exists() {
    local cmd="$1"
    [[ -n "${CMD_CACHE[$cmd]}" ]] && return "${CMD_CACHE[$cmd]}"

    if command -v "$cmd" >/dev/null 2>&1; then
        CMD_CACHE[$cmd]=0
        return 0
    else
        CMD_CACHE[$cmd]=1
        return 1
    fi
}

# Function to check if media is playing via playerctl (optimized)
check_playerctl() {
    cmd_exists playerctl || return 1

    # Direct status check without grep
    local status
    status=$(playerctl status 2>/dev/null) || return 1
    [[ "$status" == "Playing" ]] && return 0
    return 1
}

# Function to check if media is playing via pactl (improved and more selective)
check_pulseaudio() {
    cmd_exists pactl || return 1

    # Get detailed sink input information
    local sink_info
    sink_info=$(pactl list sink-inputs 2>/dev/null)

    # Check if there are any sink inputs at all
    [[ -z "$sink_info" ]] && return 1

    # Look for media-related applications or streams
    # Exclude system sounds and notification sounds
    if echo "$sink_info" | grep -E "(application\.name = \"(firefox|chromium|chrome|mpv|vlc|spotify|totem|mplayer|celluloid|Nightly|Firefox)\")" >/dev/null 2>&1; then
        return 0
    fi

    # Check for streams that are likely media (not just system audio)
    # Look for stereo streams with reasonable sample rates
    if echo "$sink_info" | grep -E "(Channels: 2|Sample Specification: s16le 2ch|float32le 2ch)" >/dev/null 2>&1; then
        # Additional check: ensure it's not just a brief system sound
        local active_count
        active_count=$(echo "$sink_info" | grep -c "State: RUNNING")
        [[ "$active_count" -gt 0 ]] && return 0
    fi

    return 1
}

# Function to check if media is playing via pipewire (additional check)
check_pipewire() {
    cmd_exists pw-cli || return 1

    # Check for active audio streams in pipewire
    local streams
    streams=$(pw-cli info all 2>/dev/null | grep -E "state.*running.*Audio" 2>/dev/null)
    [[ -n "$streams" ]] && return 0
    return 1
}

# Function to check if video is playing (fixed)
check_video_players() {
    # Check video players individually (pgrep -x doesn't support pipe separated patterns)
    if pgrep -x mpv >/dev/null 2>&1 || \
       pgrep -x vlc >/dev/null 2>&1 || \
       pgrep -x totem >/dev/null 2>&1 || \
       pgrep -x mplayer >/dev/null 2>&1 || \
       pgrep -x celluloid >/dev/null 2>&1 || \
       pgrep -x kodi >/dev/null 2>&1; then
        return 0
    fi

    # Check browsers with media only if they're running
    if pgrep -x firefox >/dev/null 2>&1 || \
       pgrep -x chromium >/dev/null 2>&1 || \
       pgrep -x chrome >/dev/null 2>&1 || \
       pgrep -x firefox-esr >/dev/null 2>&1; then
        check_playerctl && return 0
    fi

    return 1
}

# Function to check if any streaming services are active (fixed)
check_streaming() {
    # Check streaming and communication apps individually
    if pgrep -x spotify >/dev/null 2>&1 || \
       pgrep -x discord >/dev/null 2>&1 || \
       pgrep -x teams >/dev/null 2>&1 || \
       pgrep -x zoom >/dev/null 2>&1 || \
       pgrep -x obs >/dev/null 2>&1 || \
       pgrep -x obs-studio >/dev/null 2>&1 || \
       pgrep -x skype >/dev/null 2>&1 || \
       pgrep -x telegram-desktop >/dev/null 2>&1; then
        return 0
    fi
    return 1
}

# Main media detection function (improved with pipewire support)
is_media_playing() {
    # Check in order of speed: playerctl first (fastest), then process checks
    check_playerctl && return 0
    check_video_players && return 0
    check_streaming && return 0
    check_pulseaudio && return 0
    check_pipewire && return 0
    return 1
}

# Check the requested action (improved with debug option)
main() {
    case "$1" in
        "check")
            is_media_playing && exit 1 || exit 0
            ;;
        "debug")
            echo "=== Media Detection Debug ==="
            echo -n "playerctl: "; check_playerctl && echo "PLAYING" || echo "not playing"
            echo -n "video players: "; check_video_players && echo "DETECTED" || echo "none found"
            echo -n "streaming apps: "; check_streaming && echo "DETECTED" || echo "none found"
            echo -n "pulseaudio: "; check_pulseaudio && echo "ACTIVE" || echo "no streams"
            echo -n "pipewire: "; check_pipewire && echo "ACTIVE" || echo "no streams"
            echo -n "Overall result: "; is_media_playing && echo "MEDIA PLAYING" || echo "no media detected"
            ;;
        "lock")
            is_media_playing || loginctl lock-session 2>/dev/null
            ;;
        "suspend")
            is_media_playing || systemctl suspend 2>/dev/null
            ;;
        "dpms-off")
            is_media_playing || hyprctl dispatch dpms off 2>/dev/null
            ;;
        *)
            printf "Usage: %s {check|debug|lock|suspend|dpms-off}\n" "$0" >&2
            exit 1
            ;;
    esac
}

# Only run main function if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
