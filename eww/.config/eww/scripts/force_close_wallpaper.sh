#!/bin/bash

# Force close wallpaper widget for Hyprland keybind
# This script uses multiple aggressive methods to ensure closure

echo "Attempting to close wallpaper widget..."

# Method 1: Normal close
eww close wallpaper_widget

# Short wait
sleep 0.1

# Method 2: Check if still running and force
if eww ping > /dev/null 2>&1; then
    if eww active-windows | grep -q "wallpaper_widget"; then
        echo "Widget still active, using aggressive methods..."
        
        # Try to kill the specific window
        eww kill
        sleep 0.2
        
        # Restart daemon
        eww daemon --force-wayland > /dev/null 2>&1 &
        sleep 0.3
    fi
fi

# Method 3: Kill any EWW processes related to wallpaper
pkill -f "eww.*wallpaper" > /dev/null 2>&1

# Method 4: Nuclear option - find and kill any stuck EWW overlay windows
if command -v hyprctl > /dev/null; then
    # Get EWW window IDs and close them via Hyprland
    hyprctl clients | grep -A 10 "eww" | grep "address:" | cut -d' ' -f2 | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr" > /dev/null 2>&1
    done
fi

echo "Wallpaper widget close sequence completed."
