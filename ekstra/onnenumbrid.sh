#!/bin/bash

for arv in $(seq 1000 9999)
do
    algne=$arv
    kontroll=$arv

    while [ $kontroll -gt 9 ]
    do
        summa=0

        while [ $kontroll -gt 0 ]
        do
            number=$((kontroll % 10))
            summa=$((summa + number))
            kontroll=$((kontroll / 10))
        done

        kontroll=$summa
    done

    if [ $kontroll -eq 7 ]
    then
        echo $algne
    fi
done
