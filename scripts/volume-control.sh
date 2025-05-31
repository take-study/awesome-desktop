#!/bin/bash

# Volume control script with dunst notifications
# Usage: volume-control.sh [up|down|mute]

# Volume step (percentage)
VOLUME_STEP=5

# Get current volume and mute status (optimized and fixed)
get_volume_info() {
    local volume_output
    volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return 1
    
    # Extract volume float value
    local volume_float=${volume_output#*Volume: }
    volume_float=${volume_float%% *}
    
    # Convert float to percentage properly (multiply by 100 and round)
    local volume
    volume=$(printf "%.0f" "$(echo "$volume_float * 100" | bc -l 2>/dev/null)")
    
    # Fallback calculation if bc is not available
    if [[ -z "$volume" ]] || [[ "$volume" == "0" && "$volume_float" != "0.00" ]]; then
        # Alternative method using awk for float arithmetic
        volume=$(echo "$volume_float" | awk '{printf "%.0f", $1 * 100}')
    fi
    
    # Ensure volume is within valid range
    [[ "$volume" -gt 100 ]] && volume=100
    [[ "$volume" -lt 0 ]] && volume=0
    
    # Check mute status
    [[ "$volume_output" == *"MUTED"* ]] && printf "$volume:yes" || printf "$volume:no"
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
    local filled_length=$((volume * bar_length / 100 ))
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
main() {
    case "$1" in
        "up")
            wpctl set-volume @DEFAULT_AUDIO_SINK@ ${VOLUME_STEP}%+ 2>/dev/null
            # Cap volume at 100% using proper float comparison
            volume_output=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
            volume_float=${volume_output#*Volume: }
            volume_float=${volume_float%% *}
            
            # Check if volume exceeds 1.0 using awk for float comparison
            if echo "$volume_float 1.0" | awk '{exit ($1 > $2) ? 0 : 1}' 2>/dev/null; then
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

    # Get updated volume info and send notification (with error handling)
    volume_info=$(get_volume_info)
    if [[ -n "$volume_info" ]]; then
        IFS=':' read -r volume mute_status <<< "$volume_info"
        send_notification "$volume" "$mute_status"
    else
        # Fallback notification if volume info retrieval fails
        dunstify -a "Volume Control" \
                 -u normal \
                 -h string:x-canonical-private-synchronous:volume \
                 "🔊 音量控制" \
                 "无法获取音量信息" >/dev/null 2>&1
    fi
}

# Only run main function if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
