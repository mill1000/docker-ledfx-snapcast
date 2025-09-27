#!/usr/bin/env sh

# Start pipewire and wireplumber
pipewire $PIPEWIRE_OPTS&
wireplumber $WIREPLUMBER_OPTS& 

# Start snapclient with pipewire backend
snapclient --player pipewire $SNAPCAST_OPTS& 

# Start LedFX
source /app/.venv/bin/activate && ledfx -c /app/ledfx $LEDFX_OPTS
