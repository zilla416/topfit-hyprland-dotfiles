#!/usr/bin/env bash
WALLPATH="$1"
FADE="${2:-fade}"

# Close the wallpaper widget
eww close wallpaper_widget

# Change wallpaper with smooth fade transition
# Uses fade transition with longer duration and bezier easing for smooth effect
swww img "$WALLPATH" \
    --transition-type fade \
    --transition-duration 8 \
    --transition-fps 60 \
    --transition-bezier 0.4,0.0,0.2,1.0

# Generate pywal color scheme
wal -i "$WALLPATH"

# Read accent color and set Hyprland border
ACCENT=$(jq -r '.colors[0]' ~/.cache/wal/colors.json | sed 's/#//')
hyprctl keyword general:col.active_border "rgb($ACCENT)"
