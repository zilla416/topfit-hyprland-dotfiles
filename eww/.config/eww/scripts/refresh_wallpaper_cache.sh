#!/bin/bash

# Script to manually refresh wallpaper cache
# Use this after adding/removing wallpapers to force an immediate refresh

echo "Refreshing wallpaper cache..."
rm -f /tmp/eww-thumbnails/.cache*
echo "Cache cleared. Next widget open will rescan wallpapers."
