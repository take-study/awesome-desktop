#!/bin/bash

# Tofi Calculator Script (optimized)
# Advanced calculator using tofi and bc for mathematical expressions

# Cache for command availability
declare -A CMD_CACHE

# Check if command exists (with caching)
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

# Send notification using dunst (optimized)
send_notification() {
    local title="$1"
    local summary="${2:-Calculator}"
    local message="$3"
    local urgency="${4:-normal}"
    
    # Use dunstify if available, suppress output
    if cmd_exists dunstify; then
        dunstify -a "$title" -u "$urgency" "$summary" "$message" >/dev/null 2>&1
    elif cmd_exists notify-send; then
        notify-send -u "$urgency" "$title" "$message" >/dev/null 2>&1
    fi
}

# Quick dependency check (optimized)
check_dependencies() {
    local missing=()
    
    cmd_exists bc || missing+=("bc")
    cmd_exists wl-copy || missing+=("wl-clipboard") 
    cmd_exists tofi || missing+=("tofi")
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        send_notification "Calculator Error" "Missing dependencies:" "${missing[*]}" "critical"
        exit 1
    fi
}

# Check dependencies first
check_dependencies

# Get user input through tofi (optimized)
input=$(echo "" | tofi \
    --prompt-text "{{calc_prompt}}" \
    --width 600 \
    --height 250 \
    --num-results 1 \
    --require-match false \
    --auto-accept-single false \
    --placeholder-text "Enter expression (e.g., sqrt(16), sin(pi/2), 2^8)" 2>/dev/null)

# Exit if no input
[[ -z "$input" ]] && exit 0

# Enhanced input validation (optimized with single regex check)
validate_input() {
    local expr="$1"
    
    # Remove spaces and check for empty
    expr=${expr// /}
    [[ -z "$expr" ]] && return 1
    
    # Single comprehensive dangerous pattern check
    [[ "$expr" =~ [\$\`\;\|\&\>\<] ]] && return 1
    [[ "$expr" =~ (sudo|rm|cat|exec|eval|system|import|include) ]] && return 1
    
    # Check allowed mathematical characters only
    [[ "$expr" =~ ^[0-9+*/.()^epi[:alpha:]-]+$ ]] || return 1
    
    # Remove functions and validate remaining characters
    local safe_expr="${expr//sqrt/}"
    safe_expr="${safe_expr//sin/}" 
    safe_expr="${safe_expr//cos/}"
    safe_expr="${safe_expr//tan/}"
    safe_expr="${safe_expr//log/}"
    safe_expr="${safe_expr//ln/}"
    safe_expr="${safe_expr//exp/}"
    safe_expr="${safe_expr//abs/}"
    safe_expr="${safe_expr//pi/}"
    safe_expr="${safe_expr//atan/}"
    safe_expr="${safe_expr//asin/}"
    safe_expr="${safe_expr//acos/}"
    
    [[ "$safe_expr" =~ ^[0-9+*/.()^-]*$ ]]
}

# Validate input (exit on failure)
validate_input "$input" || {
    send_notification "Calculator Error" "Invalid expression: $input" "critical"
    exit 1
}

# Enhanced function replacement for bc compatibility (optimized)
process_input() {
    local expr="$1"
    
    # Replace constants using parameter expansion (faster than sed)
    expr="${expr//pi/3.14159265358979323846}"
    expr="${expr//e/2.71828182845904523536}"
    
    # Replace functions more efficiently
    expr="${expr//sqrt(/sqrt(}"
    expr="${expr//sin(/s(}"
    expr="${expr//cos(/c(}"
    expr="${expr//tan(/s(/c(}"
    expr="${expr//atan(/a(}"
    expr="${expr//log(/l(}"
    expr="${expr//ln(/l(}"
    expr="${expr//exp(/e(}"
    expr="${expr//abs(/sqrt(^2)}"
    
    printf "%s" "$expr"
}

# Process input and calculate (optimized)
input_processed=$(process_input "$input")
result=$(printf "scale=8; %s\n" "$input_processed" | bc -l 2>/dev/null)

# Handle results (optimized)
if [[ -n "$result" && "$result" != "0" ]]; then
    # Simple result formatting
    result_formatted="${result%.*}"
    [[ "${result##*.}" != "00000000" ]] && result_formatted="${result%.0*}"
    
    # Truncate long results
    if [[ ${#result_formatted} -gt 15 ]]; then
        display_text="$input = ${result_formatted:0:15}..."
        full_result="$result_formatted"
    else
        display_text="$input = $result_formatted"
        full_result="$result_formatted"
    fi
    
    # Show result (suppress tofi output)
    printf "%s\n" "$display_text" | tofi \
        --prompt-text "{{result_prompt}}" \
        --width 700 \
        --height 250 \
        --num-results 1 \
        --require-match false \
        --placeholder-text "Result copied to clipboard" >/dev/null 2>&1
    
    # Copy to clipboard (suppress output)
    printf "%s" "$full_result" | wl-copy 2>/dev/null
else
    # Show error (suppress output)
    printf "Error: %s\n" "$input" | tofi \
        --prompt-text "{{error_prompt}}" \
        --width 600 \
        --height 200 \
        --num-results 1 \
        --require-match false >/dev/null 2>&1
    
    send_notification "Calculator Error" "Invalid expression: $input" "critical"
fi
