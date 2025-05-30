#!/bin/bash

# Tofi Calculator Script
# Advanced calculator using tofi and bc for mathematical expressions
# Supports complex mathematical functions and improved error handling
# Uses dunst for notifications instead of libnotify

# Send notification using dunst
send_notification() {
    local title="$1"
    local summary="${2:-Calculator}"
    local message="$3"
    local urgency="${4:-normal}"
    
    # Use dunstify if available, otherwise fall back to notify-send
    if command -v dunstify >/dev/null 2>&1; then
        dunstify -a "$title" \
                 -u "$urgency" \
                 "$summary" \
                 "$message"
    elif command -v notify-send >/dev/null 2>&1; then
        notify-send -u "$urgency" -t "$timeout" "$title" "$message"
    else
        echo "Notification: $title - $message" >&2
    fi
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    local warnings=()
    
    command -v bc >/dev/null 2>&1 || missing_deps+=("bc")
    command -v wl-copy >/dev/null 2>&1 || missing_deps+=("wl-clipboard")
    command -v tofi >/dev/null 2>&1 || missing_deps+=("tofi")
    
    # Check for notification tools (prefer dunstify)
    if ! command -v dunstify >/dev/null 2>&1 && ! command -v notify-send >/dev/null 2>&1; then
        warnings+=("notification system (dunstify or notify-send)")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        send_notification "Calculator Error" "Missing dependencies:" "${missing_deps[*]}\nPlease install them first." "critical"
        exit 1
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        echo "Warning: ${warnings[*]} not available - notifications disabled" >&2
    fi
}

# Check dependencies first
check_dependencies

# Get user input through tofi with improved configuration
input=$(echo "" | tofi \
    --prompt-text {{calc_prompt}} \
    --width 600 \
    --height 250 \
    --num-results 1 \
    --require-match false \
    --auto-accept-single false \
    --placeholder-text "Enter mathematical expression (e.g., sqrt(16), sin(pi/2), 2^8)")

# Check if input is empty or user cancelled
if [ -z "$input" ]; then
    exit 0
fi

# Enhanced input validation - allow more mathematical functions and constants
validate_input() {
    local expr="$1"
    
    # Remove spaces for easier validation
    expr_clean=$(echo "$expr" | tr -d ' ')
    
    # Empty expression is invalid
    if [ -z "$expr_clean" ]; then
        return 1
    fi
    
    # Check for dangerous patterns using multiple separate checks to avoid grep issues
    if echo "$expr_clean" | grep -q '\$'; then return 1; fi
    if echo "$expr_clean" | grep -q '`'; then return 1; fi
    if echo "$expr_clean" | grep -q ';'; then return 1; fi
    if echo "$expr_clean" | grep -q '&'; then return 1; fi
    if echo "$expr_clean" | grep -q '|'; then return 1; fi
    if echo "$expr_clean" | grep -q '>'; then return 1; fi
    if echo "$expr_clean" | grep -q '<'; then return 1; fi
    if echo "$expr_clean" | grep -qE '(sudo|rm|cat|exec|eval|system|import|include)\b'; then return 1; fi
    
    # Allow mathematical expressions with extended function support
    # Check if expression contains only allowed characters
    if echo "$expr_clean" | grep -qE '^[0-9+*/.()^epi abcdefghijklmnopqrstuvwxyz-]+$'; then
        # Additional safety check - remove known mathematical functions and constants
        local safe_expr
        safe_expr=$(echo "$expr_clean" | sed \
            -e 's/sqrt//g' \
            -e 's/asin//g' -e 's/acos//g' -e 's/atan//g' \
            -e 's/sin//g' -e 's/cos//g' -e 's/tan//g' \
            -e 's/log//g' -e 's/ln//g' -e 's/exp//g' \
            -e 's/abs//g' -e 's/floor//g' -e 's/ceil//g' \
            -e 's/pi//g' -e 's/\be\b//g')
        
        # After removing known functions, check if only valid mathematical characters remain
        if echo "$safe_expr" | grep -qE '^[0-9+*/.()^-]*$'; then
            return 0  # Valid expression
        fi
    fi
    
    return 1  # Invalid expression
}

# Validate input
if ! validate_input "$input"; then
    send_notification "Calculator Error" "Invalid or potentially unsafe expression: $input\nOnly mathematical expressions are allowed." "critical"
    exit 1
fi

# Enhanced function replacement for bc compatibility with better mathematical support
process_input() {
    local expr="$1"
    
    # Replace mathematical constants first
    expr=$(echo "$expr" | sed \
        -e 's/\bpi\b/3.14159265358979323846/g' \
        -e 's/\be\b/2.71828182845904523536/g')
    
    # Enhanced mathematical functions replacement for bc compatibility
    expr=$(echo "$expr" | sed \
        -e 's/\bsqrt(\([^)]*\))/sqrt(\1)/g' \
        -e 's/\bsin(\([^)]*\))/s(\1)/g' \
        -e 's/\bcos(\([^)]*\))/c(\1)/g' \
        -e 's/\btan(\([^)]*\))/s(\1)\/c(\1)/g' \
        -e 's/\basin(\([^)]*\))/a(s(\1)\/sqrt(1-s(\1)^2))/g' \
        -e 's/\bacos(\([^)]*\))/a(sqrt(1-(\1)^2)\/(\1))/g' \
        -e 's/\batan(\([^)]*\))/a(\1)/g' \
        -e 's/\blog(\([^)]*\))/l(\1)/g' \
        -e 's/\bln(\([^)]*\))/l(\1)/g' \
        -e 's/\bexp(\([^)]*\))/e(\1)/g' \
        -e 's/\babs(\([^)]*\))/sqrt((\1)^2)/g' \
        -e 's/\bfloor(\([^)]*\))/(\1\/1)/g' \
        -e 's/\bceil(\([^)]*\))/(\1\/1+1)/g')
    
    # Handle exponentiation operator conversion (^ to ^)
    expr=$(echo "$expr" | sed 's/\([0-9)]\)\^\([0-9(]\)/\1^\2/g')
    
    return $expr
}

# Process the input
input_processed=$(process_input "$input")

# Perform calculation with bc using higher precision and proper math library
result=$(echo "scale=10; $input_processed" | bc -l 2>/dev/null)
exit_code=$?

# Check if calculation was successful and handle results
if [ $exit_code -eq 0 ] && [ -n "$result" ]; then
    # Format result - remove excessive trailing zeros but keep significant ones
    result_formatted=$(echo "$result" | sed 's/^\([0-9]*\)\.\([0-9]*[1-9]\)0*$/\1.\2/' | sed 's/\.$//')
    
    # If result is still empty after formatting, use original
    if [ -z "$result_formatted" ]; then
        result_formatted="$result"
    fi
    
    # Handle very small numbers (scientific notation)
    if echo "$result_formatted" | grep -qE '^\.0*[1-9]'; then
        result_formatted="0$result_formatted"
    fi
    
    # For very long results, truncate but show full precision option
    if [ ${#result_formatted} -gt 15 ]; then
        result_display="${result_formatted:0:15}..."
        full_result="$result_formatted"
    else
        result_display="$result_formatted"
        full_result="$result_formatted"
    fi
    
    # Show result in tofi with better formatting
    display_text="$input = $result_display"
    if [ "$result_display" != "$full_result" ]; then
        display_text="$display_text (truncated)"
    fi
    
    echo "$display_text" | tofi \
        --prompt-text "{{result_prompt}}" \
        --width 700 \
        --height 250 \
        --num-results 1 \
        --require-match false \
        --placeholder-text "Press Enter to copy result, Escape to close"
    
    # Copy full result to clipboard (Wayland)
    echo "$full_result" | wl-copy 2>/dev/null
    
else
    # Enhanced error reporting with helpful suggestions
    error_msg="Invalid mathematical expression: $input"
    
    # Provide context-specific suggestions
    if echo "$input" | grep -q '[a-zA-Z]'; then
        if echo "$input" | grep -qE '\b(sin|cos|tan|sqrt|log|ln|exp|abs)\b'; then
            error_msg="$error_msg\nHint: Check function syntax, e.g., sin(pi/2), sqrt(16), log(10)"
        elif echo "$input" | grep -qE '\b(asin|acos|atan)\b'; then
            error_msg="$error_msg\nNote: Inverse trig functions have limited bc support"
        else
            error_msg="$error_msg\nSupported functions: sin, cos, tan, atan, sqrt, log, ln, exp, abs"
        fi
    elif echo "$input" | grep -q '[^0-9+\-*/.()^ ]'; then
        error_msg="$error_msg\nOnly numbers and operators (+, -, *, /, ^, parentheses) allowed"
    elif echo "$input" | grep -q '/0'; then
        error_msg="$error_msg\nDivision by zero detected"
    fi
    
    # Show error in tofi as well
    echo "Error: $input" | tofi \
        --prompt-text "{{error_prompt}}" \
        --width 600 \
        --height 200 \
        --num-results 1 \
        --require-match false \
        --placeholder-text "Press Escape to close"
    
    send_notification "Calculator Error" "Calculator Error" "$error_msg" "critical"
fi
