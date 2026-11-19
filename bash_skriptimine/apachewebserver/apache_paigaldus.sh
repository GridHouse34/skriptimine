#!/bin/bash

echo "Millist veebiserverit soovid paigaldada? (apache / nginx):"
read VALIK

case "$VALIK" in
    apache|apache2|Apache|Apache2)
        TEENUS="apache2"
        ;;
    nginx|Nginx)
        TEENUS="nginx"
        ;;
    *)
        echo "Pane kirja ikka üleval loetelus olev teenus, eksole?."
        exit 1
        ;;
esac

OLEMAS=$(dpkg-query -W -f='${Status}' "$TEENUS" 2>/dev/null | grep -c "ok installed")

if [ "$OLEMAS" -eq 0 ]; then
    echo "$TEENUS ei ole paigaldatud. Alustan paigaldamist..."
    sudo apt update
    sudo apt install -y "$TEENUS"
    echo "$TEENUS on edukalt paigaldatud!"
    systemctl status "$TEENUS" --no-pager
elif [ "$OLEMAS" -eq 1 ]; then
    echo "$TEENUS on juba paigaldatud."
    systemctl status "$TEENUS" --no-pager
fi
