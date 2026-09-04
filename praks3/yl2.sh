#!/bin/bash

# Küpsise tordi valmistamise abiskript

read -p "Sisesta kandiku pikkus (cm): " pikkus
read -p "Sisesta kandiku laius (cm): " laius
read -p "Sisesta küpsise pikkus (cm): " kpikkus
read -p "Sisesta küpsise laius (cm): " klaius
read -p "Sisesta kihtide arv: " kihte
read -p "Sisesta küpsiste arv pakis: " pakis

# Arvutame küpsiste arvu ühes kihis
pikkus_tk=$(expr $pikkus / $kpikkus)
laius_tk=$(expr $laius / $klaius)
kihi_kypsised=$(expr $pikkus_tk \* $laius_tk)

# Arvutame kokku vajaminevad küpsised
kokku_kypsised=$(expr $kihi_kypsised \* $kihte)

# Arvutame pakkide arvu (ümardades ülespoole)
pakke=$(expr \( $kokku_kypsised + $pakis - 1 \) / $pakis)

echo "Kokku on vaja $kokku_kypsised küpsist."
echo "Poeid tuleb osta $pakke pakki küpsiseid."
