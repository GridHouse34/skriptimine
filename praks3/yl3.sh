#!/bin/bash

# Bussi ekskursiooni kohtade arvutaja või midagi taolist.

read -p "Sisesta reisijate arv: " reisijad
read -p "Sisesta kohtade arv bussis: " kohad

# Täielikult täidetud bussid
bussid=$(expr $reisijad / $kohad)

# Maha jäänud inimesed (jääk)
maha=$(expr $reisijad % $kohad)

echo "Täielikult täidetud busse: $bussid"
echo "Maha jäänud inimesi: $maha"
