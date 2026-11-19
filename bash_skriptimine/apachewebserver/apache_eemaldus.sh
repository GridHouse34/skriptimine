#!/bin/bash

APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")

if [ "$APACHE2" -eq 0 ]; then
    echo "Apache2 ei ole paigaldatud."
elif [ "$APACHE2" -eq 1 ]; then
    echo "Apache2 on paigaldatud. Alustan eemaldamist..."
    sudo systemctl stop apache2
    sudo apt purge -y apache2
    sudo apt autoremove -y
    echo "Apache2 on edukalt eemaldatud!"
fi
