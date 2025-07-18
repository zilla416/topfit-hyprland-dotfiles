#!/bin/bash

# Create thumbnails directory if it doesn't exist
mkdir -p /tmp/eww-thumbnails

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
done < <(find /home/jaiden/Pictures/wallpapers -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.webp' \) -print0)

# Output display paths as JSON array (thumbnails for GIFs, originals for others)
printf '%s\n' "${display_paths[@]}" | jq -R -s -c 'split("\n")[:-1]'
