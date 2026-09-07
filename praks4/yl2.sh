#!/bin/bash

# uuendatud bussi arvutamis skript vist. peaks suurendama busside arvu ühe võrra kui reisijaid ei mahu ühte enam.

echo -n "Sisesta reisijate arv: "
read reisijad
echo -n "Sisesta kohtade arv bussis: "
read kohad

bussid=$(($reisijad / $kohad))
ylejaanud=$(($reisijad % $kohad))

if [ $ylejaanud -gt 0 ]
then
    bussid=$(($bussid + 1))
fi

echo "Kokku on vaja $bussid bussi"
