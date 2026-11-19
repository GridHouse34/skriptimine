#!/bin/bash

APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")
NGINX=$(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed")

if [ "$APACHE2" -eq 0 ] && [ "$NGINX" -eq 0 ]; then
    echo "Kumbagi veebiserverit (apache2 ega nginx) ei ole paigaldatud. Vist."
else
    if [ "$APACHE2" -eq 1 ]; then
        echo "Apache2 on paigaldatud. Hasta la vista HTML."
        sudo systemctl stop apache2
        sudo apt purge -y apache2
        echo "Apache2 on ametlikult Tartu Vanglasse kinni pantud."
    fi

    if [ "$NGINX" -eq 1 ]; then
        echo "Nginx on paigaldatud. Päriselt? Sa kasutasid seda? No hea asi, et ma siin olen siis."
        sudo systemctl stop nginx
        sudo apt purge -y nginx
        echo "Nginx on kaudunud. Whoops."
    fi

    sudo apt autoremove --purge -y
fi
