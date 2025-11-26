#!/bin/bash

# Create thumbnails directory if it doesn't exist
mkdir -p /tmp/eww-thumbnails

# Cache file to track last scan
CACHE_FILE="/tmp/eww-thumbnails/.cache"
WALLPAPER_DIR="/home/jaiden/Pictures/wallpapers"

# Check if we need to rescan (only if wallpaper dir changed or cache is old)
NEEDS_SCAN=false
if [ ! -f "$CACHE_FILE" ]; then
    NEEDS_SCAN=true
else
    # Check if wallpaper directory has been modified since last scan
    if [ "$WALLPAPER_DIR" -nt "$CACHE_FILE" ]; then
        NEEDS_SCAN=true
    fi
fi

# If cache exists and is recent, use it
if [ "$NEEDS_SCAN" = false ] && [ -f "$CACHE_FILE.json" ]; then
    cat "$CACHE_FILE.json"
    exit 0
fi

# Array to store wallpaper paths (for thumbnails) and original paths (for script)
wallpapers=()

# Find all wallpaper files
while IFS= read -r -d '' file; do
    if [[ "$file" == *.gif ]]; then
        # Generate thumbnail filename
        basename=$(basename "$file" .gif)
        thumbnail="/tmp/eww-thumbnails/${basename}.png"
        
        # Generate thumbnail if it doesn't exist or if the original is newer
        if [[ ! -f "$thumbnail" ]] || [[ "$file" -nt "$thumbnail" ]]; then
            # Use ffmpeg to extract first frame as PNG thumbnail
            ffmpeg -i "$file" -vframes 1 -y "$thumbnail" 2>/dev/null
        fi
        
        # Add thumbnail path to array (but store original path for onclick)
        if [[ -f "$thumbnail" ]]; then
            wallpapers+=("$file")  # Still use original path so script gets the .gif file
        fi
    else
        # For non-GIF files, just add them directly
        wallpapers+=("$file")
    fi
done < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) -print0 | sort -z)

# Output as JSON array for EWW and cache it
output=$(printf '%s\n' "${wallpapers[@]}" | jq -R -s -c 'split("\n")[:-1]')
echo "$output" > "$CACHE_FILE.json"
touch "$CACHE_FILE"
echo "$output"
