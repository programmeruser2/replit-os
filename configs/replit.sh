#!/bin/bash
cat ~/.config/chromium/Local\ State | perl -pe "s/\"bottom.*/\"bottom\": $(xrandr | grep \* | cut -d' ' -f4 | cut -d'x' -f2),/" > ~/.config/chromium/Local\ State
cat ~/.config/chromium/Local\ State | perl -pe "s/\"right.*/\"right\": $(xrandr | grep \* | cut -d' ' -f4 | cut -d'x' -f1),/" > ~/.config/chromium/Local\ State
while true; do chromium-browser https://repl.it --kiosk --start-maximized; done
