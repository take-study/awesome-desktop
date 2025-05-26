#!/bin/bash

# Volume control script with dunst notifications
# Usage: volume-control.sh [up|down|mute]

# Volume step (percentage)
VOLUME_STEP=5

# Get current volume and mute status
get_volume_info() {
    local volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    local volume=$(echo "$volume_output" | grep -Po '\d+\.\d+' | awk '{print int($1*100)}')
    local mute_status=$(echo "$volume_output" | grep -q 'MUTED' && echo "yes" || echo "no")
    echo "$volume:$mute_status"
}

# Send notification with dunst
send_notification() {
    local volume="$1"
    local mute_status="$2"
    local icon=""
    local message=""
    
    # Determine icon and message based on volume and mute status
    if [[ "$mute_status" == "yes" ]]; then
        icon="󰖁"
        message="音量已静音"
        volume=0
    elif [[ "$volume" -eq 0 ]]; then
        icon="󰕿"
        message="音量: ${volume}%"
    elif [[ "$volume" -le 30 ]]; then
        icon="󰖀"
        message="音量: ${volume}%"
    elif [[ "$volume" -le 70 ]]; then
        icon="󰕾"
        message="音量: ${volume}%"
    else
        icon="󰕾"
        message="音量: ${volume}%"
    fi
    
    # Create progress bar
    local bar_length=20
    local filled_length=$((volume * bar_length / 100))
    local progress_bar=""
    
    for ((i=0; i<bar_length; i++)); do
        if [[ i -lt filled_length ]]; then
            progress_bar+="█"
        else
            progress_bar+="░"
        fi
    done
    
    # Send notification using dunst
    dunstify -a "Volume Control" \
             -u normal \
             -h string:x-canonical-private-synchronous:volume \
             "$icon $message" \
             "$progress_bar"
}

# Main volume control logic
case "$1" in
    "up")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%+
        # Cap volume at 100%
        current_volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
        current_volume=$(echo "$current_volume_output" | grep -Po '\d+\.\d+' | awk '{print int($1*100)}')
        if [[ "$current_volume" -gt 100 ]]; then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0
        fi
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%-
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        echo "  up    - Increase volume by ${VOLUME_STEP}%"
        echo "  down  - Decrease volume by ${VOLUME_STEP}%"
        echo "  mute  - Toggle mute/unmute"
        exit 1
        ;;
esac

# Get updated volume info and send notification
volume_info=$(get_volume_info)
volume=$(echo "$volume_info" | cut -d':' -f1)
mute_status=$(echo "$volume_info" | cut -d':' -f2)

send_notification "$volume" "$mute_status"
