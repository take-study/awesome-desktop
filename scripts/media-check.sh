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

# Function to check if media is playing via pactl (optimized)  
check_pulseaudio() {
    cmd_exists pactl || return 1
    
    # More efficient check for running sink inputs
    pactl list short sink-inputs 2>/dev/null | grep -q . && return 0
    return 1
}

# Function to check if video is playing (optimized)
check_video_players() {
    # Use single pgrep call with multiple patterns
    if pgrep -x 'mpv|vlc|totem|mplayer' >/dev/null 2>&1; then
        return 0
    fi
    
    # Check browsers with media only if they're running
    if pgrep -x 'firefox|chromium|chrome' >/dev/null 2>&1; then
        check_playerctl && return 0
    fi
    
    return 1
}

# Function to check if any streaming services are active (optimized)
check_streaming() {
    # Single pgrep call for all streaming apps
    pgrep -x 'spotify|discord|teams|zoom|obs|obs-studio' >/dev/null 2>&1
}

# Main media detection function (optimized with early exit)
is_media_playing() {
    # Check in order of speed: playerctl first (fastest), then process checks
    check_playerctl && return 0
    check_video_players && return 0  
    check_streaming && return 0
    check_pulseaudio && return 0
    return 1
}

# Check the requested action (optimized with reduced output)
case "$1" in
    "check")
        is_media_playing && exit 1 || exit 0
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
        printf "Usage: %s {check|lock|suspend|dpms-off}\n" "$0" >&2
        exit 1
        ;;
esac
