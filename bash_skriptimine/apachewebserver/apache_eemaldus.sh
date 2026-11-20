#!/bin/bash

APACHE2=$(dpkg-query -W -f='${Status}' apache2 2>/dev/null | grep -c "ok installed")
NGINX=$(dpkg-query -W -f='${Status}' nginx 2>/dev/null | grep -c "ok installed")
PHP=$(dpkg-query -W -f='${Status}' php 2>/dev/null | grep -c "ok installed")
MYSQL=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed")

if [ "$APACHE2" -eq 0 ] && [ "$NGINX" -eq 0 ] && [ "$PHP" -eq 0 ] && [ "$MYSQL" -eq 0 ]; then
    echo "Ühtegi teenust (apache2, nginx, php ega mysql-server) ei ole paigaldatud."
    exit 0
fi

if [ "$APACHE2" -eq 1 ]; then
    echo "Eemaldan Apache2..."
    sudo systemctl stop apache2
    sudo apt purge -y apache2
fi

if [ "$NGINX" -eq 1 ]; then
    echo "Eemaldan Nginx..."
    sudo systemctl stop nginx
    sudo apt purge -y nginx
fi

if [ "$PHP" -eq 1 ]; then
    echo "Eemaldan PHP..."
    sudo apt purge -y 'php*'
fi

if [ "$MYSQL" -eq 1 ]; then
    echo "Eemaldan MySQL serveri ja seadistused..."
    sudo systemctl stop mysql
    sudo apt purge -y mysql-server mysql-client mysql-common mysql-apt-config
    sudo rm -rf /etc/mysql /var/lib/mysql /var/log/mysql /var/run/mysqld
    rm -f "$HOME/.my.cnf"
fi

sudo apt autoremove --purge -y
sudo apt autoclean
echo "Kõik paigaldatud teenused on edukalt eemaldatud!"
