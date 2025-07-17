#!/bin/bash
ws=$(hyprctl clients -j | jq -r '.[] | select(.class=="Spotify") | .workspace.id' | head -n 1)

if [ -n "$ws" ]; then
    hyprctl dispatch workspace "$ws"
else
    spotify &
fi
