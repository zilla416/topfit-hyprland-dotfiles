#!/usr/bin/env bash
WALLPATH="$1"
FADE="$2"

# Change wallpaper
swww img "$WALLPATH" --transition-type "$FADE"

# Generate pywal color scheme
wal -i "$WALLPATH"

# Read accent color and set Hyprland border
ACCENT=$(jq -r '.colors[0]' ~/.cache/wal/colors.json | sed 's/#//')
hyprctl keyword general:col.active_border "rgb($ACCENT)"
