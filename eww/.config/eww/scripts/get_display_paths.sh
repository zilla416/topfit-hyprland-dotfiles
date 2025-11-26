#!/bin/bash

# Create thumbnails directory if it doesn't exist
mkdir -p /tmp/eww-thumbnails

# Cache file to track last scan
CACHE_FILE="/tmp/eww-thumbnails/.cache_display"
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

# Create two arrays: one for display paths, one for original paths
display_paths=()
original_paths=()

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
        
        # Add paths to arrays
        if [[ -f "$thumbnail" ]]; then
            display_paths+=("$thumbnail")    # Thumbnail for display
            original_paths+=("$file")        # Original for onclick
        fi
    else
        # For non-GIF files, use the same path for both
        display_paths+=("$file")
        original_paths+=("$file")
    fi
done < <(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) -print0 | sort -z)

# Output display paths as JSON array (thumbnails for GIFs, originals for others) and cache it
output=$(printf '%s\n' "${display_paths[@]}" | jq -R -s -c 'split("\n")[:-1]')
echo "$output" > "$CACHE_FILE.json"
touch "$CACHE_FILE"
echo "$output"
