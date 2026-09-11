#!/bin/bash

aeg=$(date +%H)
kasutaja=$(whoami)

if [ "$aeg" -ge 6 ] && [ "$aeg" -lt 12 ]; then
    echo "Tere hommikust, $kasutaja!"
elif [ "$aeg" -ge 12 ] && [ "$aeg" -lt 18 ]; then
    echo "Tere päevast, $kasutaja!"
elif [ "$aeg" -ge 18 ] && [ "$aeg" -lt 22 ]; then
    echo "Tere õhtust, $kasutaja!"
elif [ "$aeg" -ge 22 ] && [ "$aeg" -lt 24 ] || [ "$aeg" -ge 0 ] && [ "$aeg" -lt 6 ]; then
    echo "Head ööd, $kasutaja!"
else
    echo "Vale aeg"
fi
