#!/bin/bash

> player_numbers.txt
> lottery_numbers.txt

echo "LOTOMÄNG"
echo

read -p "Sisesta mängija nimi: " player_name

if [ -z "$player_name" ]; then
    player_name="Unknown"
fi

echo
echo "Sisesta 5 erinevat numbrit vahemikus 1-50."

count=1

while [ $count -le 5 ]; do
    read -p "Sisesta number $count: " number

    if [ -z "$number" ]; then
        echo "Viga: number jäi sisestamata."
        continue
    fi

    if ! [[ "$number" =~ ^[0-9]+$ ]]; then
        echo "Viga: sisesta täisarv."
        continue
    fi

    if [ "$number" -lt 1 ] || [ "$number" -gt 50 ]; then
        echo "Viga: number peab olema vahemikus 1-50."
        continue
    fi

    if grep -qx "$number" player_numbers.txt; then
        echo "Viga: see number on juba valitud."
        continue
    fi

    echo "$number" >> player_numbers.txt
    count=$((count + 1))
done

echo
echo "Mängija valitud numbrid:"
cat player_numbers.txt

echo
echo "Loosin võidunumbrid..."

count=1

while [ $count -le 5 ]; do
    lottery_number=$((RANDOM % 50 + 1))

    if grep -qx "$lottery_number" lottery_numbers.txt; then
        continue
    fi

    echo "$lottery_number" >> lottery_numbers.txt
    count=$((count + 1))
done

echo
echo "Võidunumbrid:"
cat lottery_numbers.txt

echo
echo "Tulemuste kontrollimine:"
echo

matches=0

while read number; do
    echo "Kontrollin numbrit $number..."

    if grep -qx "$number" lottery_numbers.txt; then
        echo "TABAMUS!"
        matches=$((matches + 1))
    else
        echo "Ei tabanud."
    fi

    echo
done < player_numbers.txt

if [ "$matches" -eq 5 ]; then
    result="JACKPOT!"
elif [ "$matches" -eq 4 ]; then
    result="Väga hea tulemus!"
elif [ "$matches" -eq 3 ]; then
    result="Hea tulemus."
elif [ "$matches" -eq 2 ]; then
    result="Kaks tabamust."
elif [ "$matches" -eq 1 ]; then
    result="Üks tabamus."
else
    result="Seekord tabamusi ei olnud."
fi

echo "Mängija: $player_name"
echo "Tabamusi: $matches / 5"
echo "$result"

{
    echo "========================================"
    echo "Date: $(date)"
    echo "Player: $player_name"
    echo "Player numbers:"
    cat player_numbers.txt
    echo "Lottery numbers:"
    cat lottery_numbers.txt
    echo "Matches: $matches"
    echo "Result: $result"
} >> results.txt
