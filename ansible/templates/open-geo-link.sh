#!/bin/bash
# Read input from argument, or fall back to wl-paste if no argument was provided
input="${1:-$(wl-paste)}"

# Use NF (Number of Fields) logic to clean and convert the coordinates
coords=$(echo "$input" | tr -d "geo:" | tr -c "0-9.NSEW\n" " " | awk '{
    if (NF == 2) {
        print $1 "," $2
    } else if (NF >= 8) {
        lat = $1 + $2/60 + $3/3600
        if ($4 == "S") lat = -lat
        lon = $5 + $6/60 + $7/3600
        if ($8 == "W") lon = -lon
        print lat "," lon
    }
}')

# Launch the map application with the clean decimal coordinates
if [ -n "$coords" ]; then
    xdg-open "https://maps.google.com?q=$coords"
fi
