#!/bin/bash

#küsib vanust kasutaja käest ja väljastab vastava gruppi kuhu kasutaja sobib

read -p "Sisesta oma vanus: " vanus

if [ "$vanus" -ge 0 ] && [ "$vanus" -le 11 ]; then
    echo "Oled laps"
elif [ "$vanus" -ge 11 ] && [ "$vanus" -lt 18 ]; then
    echo "Oled nooruk"
elif [ "$vanus" -ge 18 ] && [ "$vanus" -lt 63 ]; then
    echo "Oled täiskasvanu"
elif [ "$vanus" -ge 63 ]; then
    echo "Oled seenior"
else
    echo "Vigane vanus"
fi
