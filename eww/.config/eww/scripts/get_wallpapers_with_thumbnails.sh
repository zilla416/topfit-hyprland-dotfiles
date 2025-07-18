#!/bin/bash

# Create thumbnails directory if it doesn't exist
mkdir -p /tmp/eww-thumbnails

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
done < <(find /home/jaiden/Pictures/wallpapers -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) -print0)

# Output as JSON array for EWW
printf '%s\n' "${wallpapers[@]}" | jq -R -s -c 'split("\n")[:-1]'
