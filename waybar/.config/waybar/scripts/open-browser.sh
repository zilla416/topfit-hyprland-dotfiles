#!/bin/bash
ws=$(hyprctl clients -j | jq -r '.[] | select(.class=="zen") | .workspace.id' | head -n 1)

if [ -n "$ws" ]; then
    hyprctl dispatch workspace "$ws"
else
    /usr/bin/flatpak run --branch=stable --arch=x86_64 --command=launch-script.sh --file-forwarding app.zen_browser.zen @@u @@ &
fi
