#!/bin/bash

# --- 1. Setup Directories ---
BASE_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
OUTPUT_DIR="$BASE_DIR/Screenshots"
LOG_FILE="/tmp/screenshot_debug.log"

# Clear log for new run
echo "--- Starting Screenshot Script $(date) ---" > "$LOG_FILE"

# Create directory
mkdir -p "$OUTPUT_DIR"

MODE="${1:-smart}"
PROCESSING="${2:-slurp}"

echo "Mode: $MODE, Processing: $PROCESSING" >> "$LOG_FILE"

# --- 2. Fullscreen Mode (Fast Path) ---
if [[ "$MODE" == "fullscreen" ]]; then
    # Try to get active monitor name (e.g., eDP-1)
    # We use 'raw' output from jq to avoid quote issues
    ACTIVE_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

    echo "Detected Monitor: '$ACTIVE_MONITOR'" >> "$LOG_FILE"

    if [[ "$PROCESSING" == "copy" ]]; then
        if [[ -n "$ACTIVE_MONITOR" ]]; then
            # Capture specific monitor
            grim -o "$ACTIVE_MONITOR" - | wl-copy 2>> "$LOG_FILE"
        else
            # Fallback: Capture everything if monitor detection fails
            echo "Monitor detection failed, capturing full screen." >> "$LOG_FILE"
            grim - | wl-copy 2>> "$LOG_FILE"
        fi
        notify-send "Screenshot" "Fullscreen copied to clipboard" -t 1000
    else
        # Save to file and open Satty
        # Determine target file
        FILE_PATH="$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"

        if [[ -n "$ACTIVE_MONITOR" ]]; then
            grim -o "$ACTIVE_MONITOR" - | satty --filename - --output-filename "$FILE_PATH" --early-exit --copy-command 'wl-copy' --save-after-copy 2>> "$LOG_FILE"
        else
            grim - | satty --filename - --output-filename "$FILE_PATH" --early-exit --copy-command 'wl-copy' --save-after-copy 2>> "$LOG_FILE"
        fi
    fi
    exit 0
fi

# --- 3. Interactive Modes ---
pkill slurp && echo "Killed previous slurp" >> "$LOG_FILE" && exit 0

get_rectangles() {
  local active_workspace=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id')
  hyprctl monitors -j | jq -r --arg ws "$active_workspace" '.[] | select(.activeWorkspace.id == ($ws | tonumber)) | "\(.x),\(.y) \((.width / .scale) | floor)x\((.height / .scale) | floor)"'
  hyprctl clients -j | jq -r --arg ws "$active_workspace" '.[] | select(.workspace.id == ($ws | tonumber)) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

case "$MODE" in
  smart|*)
    RECTS=$(get_rectangles)
    wayfreeze & PID=$! ; sleep .1
    SELECTION=$(echo "$RECTS" | slurp 2>/dev/null)
    kill $PID 2>/dev/null

    # Smart logic for clicks (expand small selection to window size)
    if [[ "$SELECTION" =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]]; then
      if (( ${BASH_REMATCH[3]} * ${BASH_REMATCH[4]} < 20 )); then
        click_x="${BASH_REMATCH[1]}" ; click_y="${BASH_REMATCH[2]}"
        while IFS= read -r rect; do
          if [[ "$rect" =~ ^([0-9]+),([0-9]+)[[:space:]]([0-9]+)x([0-9]+) ]]; then
            rx="${BASH_REMATCH[1]}" ; ry="${BASH_REMATCH[2]}"
            rw="${BASH_REMATCH[3]}" ; rh="${BASH_REMATCH[4]}"
            if (( click_x >= rx && click_x < rx+rw && click_y >= ry && click_y < ry+rh )); then
              SELECTION="${rx},${ry} ${rw}x${rh}" ; break
            fi
          fi
        done <<< "$RECTS"
      fi
    fi
    ;;
esac

[ -z "$SELECTION" ] && echo "No selection made" >> "$LOG_FILE" && exit 0

echo "Selection: $SELECTION" >> "$LOG_FILE"

if [[ $PROCESSING == "slurp" ]]; then
    grim -g "$SELECTION" - | satty --filename - --output-filename "$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png" --early-exit --actions-on-enter save-to-clipboard --save-after-copy --copy-command 'wl-copy' 2>> "$LOG_FILE"
else
    grim -g "$SELECTION" - | wl-copy 2>> "$LOG_FILE"
fi
