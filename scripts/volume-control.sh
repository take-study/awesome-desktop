#!/bin/bash

# Volume control script with dunst notifications
# Usage: volume-control.sh [up|down|mute]

# Volume step (percentage)
VOLUME_STEP=5

# Get current volume and mute status (optimized)
get_volume_info() {
    local volume_output
    volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return 1
    
    # Extract volume and mute status in one pass using parameter expansion
    local volume_float=${volume_output#*Volume: }
    volume_float=${volume_float%% *}
    local volume=$((${volume_float%.*}${volume_float#*.} * 100 / 100))
    
    # Check mute status more efficiently
    [[ "$volume_output" == *"MUTED"* ]] && echo "$volume:yes" || echo "$volume:no"
}

# Send notification with dunst (optimized)
send_notification() {
    local volume="$1"
    local mute_status="$2"
    local icon message
    
    # Determine icon and message using case for better performance
    if [[ "$mute_status" == "yes" ]]; then
        icon="󰖁"
        message="音量已静音"
        volume=0
    else
        message="音量: ${volume}%"
        case $volume in
            0) icon="󰕿" ;;
            [1-9]|[12][0-9]|30) icon="󰖀" ;;
            *) icon="󰕾" ;;
        esac
    fi
    
    # Create progress bar more efficiently
    local bar_length=20
    local filled_length=$((volume * bar_length / 100))
    local progress_bar
    
    # Use printf for faster string building
    printf -v progress_bar '%*s' "$filled_length" ''
    progress_bar=${progress_bar// /█}
    printf -v empty_part '%*s' $((bar_length - filled_length)) ''
    progress_bar+=${empty_part// /░}
    
    # Send notification using dunst (suppress output)
    dunstify -a "Volume Control" \
             -u normal \
             -h string:x-canonical-private-synchronous:volume \
             "$icon $message" \
             "$progress_bar" >/dev/null 2>&1
}

# Main volume control logic (optimized)
case "$1" in
    "up")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%+ 2>/dev/null
        # Cap volume at 100% more efficiently
        volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
        if [[ "${volume_output#*Volume: }" > "1.0" ]]; then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 1.0 2>/dev/null
        fi
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%- 2>/dev/null
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 2>/dev/null
        ;;
    *)
        printf "Usage: %s {up|down|mute}\n" "$0" >&2
        exit 1
        ;;
esac

# Get updated volume info and send notification (suppress errors)
volume_info=$(get_volume_info) || exit 1
IFS=':' read -r volume mute_status <<< "$volume_info"
send_notification "$volume" "$mute_status"
