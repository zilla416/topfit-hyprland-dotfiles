#!/bin/bash

# Cache file for count
CACHE_FILE="/tmp/eww-thumbnails/.cache_count"
WALLPAPER_DIR="/home/jaiden/Pictures/wallpapers"

# Check if we need to rescan
if [ -f "$CACHE_FILE" ] && [ ! "$WALLPAPER_DIR" -nt "$CACHE_FILE" ]; then
    # Cache is valid, use it
    cat "$CACHE_FILE"
    exit 0
fi

# Count wallpapers efficiently without generating thumbnails
count=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) | wc -l)

# Cache the result
echo "$count" > "$CACHE_FILE"
echo "$count"
