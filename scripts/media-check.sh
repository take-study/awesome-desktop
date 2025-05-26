#!/bin/bash

# Media detection script for hypridle
# Checks if any media is currently playing and prevents suspend/lock if so

# Function to check if media is playing via playerctl
check_playerctl() {
    if command -v playerctl &> /dev/null; then
        # Check if any player is playing
        local status=$(playerctl status 2>/dev/null | grep -i "playing")
        if [[ -n "$status" ]]; then
            return 0  # Media is playing
        fi
    fi
    return 1  # No media playing
}

# Function to check if media is playing via pactl (PulseAudio)
check_pulseaudio() {
    if command -v pactl &> /dev/null; then
        # Check if any application is playing audio
        local playing=$(pactl list sink-inputs | grep -E "State: RUNNING|application.name" | grep -B1 -A1 "State: RUNNING")
        if [[ -n "$playing" ]]; then
            return 0  # Audio is playing
        fi
    fi
    return 1  # No audio playing
}

# Function to check if video is playing (common video players)
check_video_players() {
    local video_players=("mpv" "vlc" "totem" "firefox" "chromium" "chrome" "mplayer")
    
    for player in "${video_players[@]}"; do
        if pgrep -x "$player" > /dev/null; then
            # Additional check for Firefox/Chrome to see if they're actually playing video
            if [[ "$player" == "firefox" || "$player" == "chromium" || "$player" == "chrome" ]]; then
                # Check if the browser has any playing media
                if check_playerctl; then
                    return 0
                fi
            else
                return 0  # Video player is running
            fi
        fi
    done
    return 1  # No video players running
}

# Function to check if any streaming services are active
check_streaming() {
    # Check for common streaming applications
    local streaming_apps=("spotify" "discord" "teams" "zoom" "obs" "obs-studio")
    
    for app in "${streaming_apps[@]}"; do
        if pgrep -x "$app" > /dev/null; then
            return 0  # Streaming app is running
        fi
    done
    return 1  # No streaming apps running
}

# Main media detection function
is_media_playing() {
    # Check various methods for media detection
    if check_playerctl || check_pulseaudio || check_video_players || check_streaming; then
        return 0  # Media is playing
    fi
    return 1  # No media detected
}

# Check the requested action
case "$1" in
    "check")
        if is_media_playing; then
            echo "Media is playing - preventing sleep/lock"
            exit 1  # Non-zero exit prevents hypridle action
        else
            echo "No media playing - allowing sleep/lock"
            exit 0  # Zero exit allows hypridle action
        fi
        ;;
    "lock")
        if is_media_playing; then
            echo "Media playing - skipping lock"
            exit 0
        else
            loginctl lock-session
        fi
        ;;
    "suspend")
        if is_media_playing; then
            echo "Media playing - skipping suspend"
            exit 0
        else
            systemctl suspend
        fi
        ;;
    "dpms-off")
        if is_media_playing; then
            echo "Media playing - skipping screen off"
            exit 0
        else
            hyprctl dispatch dpms off
        fi
        ;;
    *)
        echo "Usage: $0 {check|lock|suspend|dpms-off}"
        echo "  check     - Check if media is playing (exit 1 if playing)"
        echo "  lock      - Lock session only if no media playing"
        echo "  suspend   - Suspend only if no media playing"
        echo "  dpms-off  - Turn off display only if no media playing"
        exit 1
        ;;
esac
