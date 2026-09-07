#!/bin/bash

read -p "Sisesta esimene sõna: " sona1
read -p "Sisesta teine sõna: " sona2

taht1=$(echo "$sona1" | rev | cut -c 1)
taht2=$(echo "$sona2" | rev | cut -c 1)

if [ "$taht1" = "$taht2" ]; then
    echo "Mõlema sõna viimane täht on sama ($taht1)."
else
    echo "Sõnade viimased tähed on erinevad ($taht1 ja $taht2)."
fi
