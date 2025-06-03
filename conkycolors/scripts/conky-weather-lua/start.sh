#!/bin/bash

cd "$(dirname "$0")"

# Controleer of Conky al draait en stop het
if pidof conky > /dev/null; then
    killall conky
fi

# Start Conky met de juiste configuratie en log fouten
conky -c ./conky.conf &

exit 0
