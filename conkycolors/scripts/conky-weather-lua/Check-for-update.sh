#!/bin/bash

cd "$(dirname "$0")"

# Checking for update for conky-config
# Check if we're in a git repository
if [ ! -d .git ]; then
    echo "Error: This is not a git repository"
    notify-send "Git Update Check" "Error: This is not a git repository" -u critical
    exit 1
fi

# Get the remote URL and ensure it uses HTTPS
REMOTE_URL=$(git remote get-url origin)
if [[ "$REMOTE_URL" == git@github.com:* ]]; then
    # Convert SSH to HTTPS
    REPO_PATH=$(echo "$REMOTE_URL" | sed 's/git@github.com:/https:\/\/github.com\//')
    git remote set-url origin "$REPO_PATH"
    echo "Remote URL converted to HTTPS: $REPO_PATH"
fi

# Fetch remote info
git fetch origin

# Compare local branch with remote
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/$CURRENT_BRANCH)

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Repository is up-to-date"
    notify-send -a Conky "Git Update Check" "conky-system-lua-V4 is up-to-date" -u low
else
    echo "Updates are available!"
    echo "Local commit: $LOCAL"
    echo "Remote commit: $REMOTE"
    echo "Use 'git pull' to download the updates"
    notify-send -a Conky "Git Update Check" "Git updates available for conky-system-lua-V4\nUse 'git pull' to download the updates" -u critical
    # Speel een belgeluid af
    if command -v paplay >/dev/null 2>&1; then
        # Gebruik PulseAudio met een standaard systeemgeluid
        paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    elif command -v aplay >/dev/null 2>&1; then
        # Fallback naar ALSA met een standaard geluid
        aplay /usr/share/sounds/alsa/Noise.wav
    else
        echo "Warning: Geen audio player (paplay of aplay) gevonden"
    fi
fi
# Exit script
exit 0