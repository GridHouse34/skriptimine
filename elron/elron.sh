#!/bin/bash

echo "ELRONI RONGIINFO"
echo
echo "Vali marsruut:"
echo
echo "1 - Tartu → Tallinn"
echo "2 - Tartu → Valga"
echo "3 - Tartu → Koidula"
echo
read -p "Sisesta valik: " valik

if [ -z "$valik" ]; then
    echo "Valik jäi sisestamata."
    exit 1
fi

case "$valik" in
    1)
        lahtejaam="Tartu"
        sihtjaam="Tallinn"
        ;;
    2)
        lahtejaam="Tartu"
        sihtjaam="Valga"
        ;;
    3)
        lahtejaam="Tartu"
        sihtjaam="Koidula"
        ;;
    *)
        echo "Vigane valik."
        exit 1
        ;;
esac

if ! vastus=$(curl -fsS "https://elron.ee/live-map/stop/$lahtejaam"); then
    echo "Elroni API päring ebaõnnestus."
    exit 1
fi

rongid=$(echo "$vastus" | grep -o '{[^}]*"sihtjaam":"'"$sihtjaam"'"[^}]*}')

if [ -z "$rongid" ]; then
    echo "Sobivaid ronge ei leitud."
    exit 1
fi

ajad=$(echo "$rongid" | grep -o '"plaaniline_aeg":"[0-9][0-9]:[0-9][0-9]"' | cut -d'"' -f4)

aeg1=$(echo "$ajad" | sed -n '1p')
aeg2=$(echo "$ajad" | sed -n '2p')
aeg3=$(echo "$ajad" | sed -n '3p')
aeg4=$(echo "$ajad" | sed -n '4p')

praegu=$(date +%H:%M)

punane=$'\e[31m'
roheline=$'\e[32m'
reset=$'\e[0m'

echo
echo "$lahtejaam → $sihtjaam"
echo "Praegune kellaaeg: $praegu"
echo
echo "Väljumised:"
echo

if [ -n "$aeg1" ]; then
    if [[ "$aeg1" < "$praegu" ]]; then
        echo "${punane}$aeg1  rong on juba väljunud${reset}"
    else
        echo "${roheline}$aeg1  rong on veel ees${reset}"
    fi
fi

if [ -n "$aeg2" ]; then
    if [[ "$aeg2" < "$praegu" ]]; then
        echo "${punane}$aeg2  rong on juba väljunud${reset}"
    else
        echo "${roheline}$aeg2  rong on veel ees${reset}"
    fi
fi

if [ -n "$aeg3" ]; then
    if [[ "$aeg3" < "$praegu" ]]; then
        echo "${punane}$aeg3  rong on juba väljunud${reset}"
    else
        echo "${roheline}$aeg3  rong on veel ees${reset}"
    fi
fi

if [ -n "$aeg4" ]; then
    if [[ "$aeg4" < "$praegu" ]]; then
        echo "${punane}$aeg4  rong on juba väljunud${reset}"
    else
        echo "${roheline}$aeg4  rong on veel ees${reset}"
    fi
fi

