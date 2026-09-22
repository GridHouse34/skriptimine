#!/bin/bash

ajutine="lotonumbrid.tmp"

> "$ajutine"

while [ $(wc -l < "$ajutine") -lt 5 ]
do
    number=$((RANDOM % 50 + 1))

    if ! grep -qx "$number" "$ajutine"
    then
        echo "$number" >> "$ajutine"
    fi
done

kuupaev=$(date "+%d.%m.%Y %H:%M:%S")

echo "Vali:"
echo "1 - kuva terminalis"
echo "2 - salvesta faili"
read valik

if [ "$valik" = "1" ]
then
    echo "Kuupäev ja kellaaeg: $kuupaev"
    echo "Lotonumbrid:"
    cat "$ajutine"

elif [ "$valik" = "2" ]
then
    echo "Kuupäev ja kellaaeg: $kuupaev" >> lototulemused.txt
    echo "Lotonumbrid:" >> lototulemused.txt
    cat "$ajutine" >> lototulemused.txt
    echo "" >> lototulemused.txt

    echo "Tulemus salvestati faili lototulemused.txt"

else
    echo "Vale valik."
fi

rm "$ajutine"
