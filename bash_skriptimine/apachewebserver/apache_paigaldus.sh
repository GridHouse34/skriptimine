#!/bin/bash

APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")

if [ "$APACHE2" -eq 0 ]; then
    echo "Apache2 ei ole paigaldatud. Alustan paigaldamist..."
    sudo apt update
    sudo apt install -y apache2
    echo "Apache2 on edukalt paigaldatud!"
    systemctl status apache2 --no-pager
elif [ "$APACHE2" -eq 1 ]; then
    echo "Apache2 on juba paigaldatud."
    systemctl status apache2 --no-pager
fi
