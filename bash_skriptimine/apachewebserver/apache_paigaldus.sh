#!/bin/bash

echo "Millist veebiserverit soovid paigaldada? (apache / nginx):"
read VALIK

case "$VALIK" in
    apache|apache2|Apache|Apache2)
        TEENUS="apache2"
        PHP_LISAD="libapache2-mod-php php-mysql"
        ;;
    nginx|Nginx)
        TEENUS="nginx"
        PHP_LISAD="php-fpm php-mysql"
        ;;
    *)
        echo "Tundmatu valik! Palun sisesta 'apache' või 'nginx'."
        exit 1
        ;;
esac

# 1. Veebiserveri kontroll ja paigaldus
WEB_OLEMAS=$(dpkg-query -W -f='${Status}' "$TEENUS" 2>/dev/null | grep -c "ok installed")

if [ "$WEB_OLEMAS" -eq 0 ]; then
    echo "$TEENUS ei ole paigaldatud. Alustan paigaldamist..."
    sudo apt update
    sudo apt install -y "$TEENUS"
    echo "$TEENUS on edukalt paigaldatud!"
    systemctl status "$TEENUS" --no-pager
elif [ "$WEB_OLEMAS" -eq 1 ]; then
    echo "$TEENUS on juba paigaldatud."
    systemctl status "$TEENUS" --no-pager
fi

echo "----------------------------------------"

# 2. PHP kontroll ja paigaldus
PHP=$(dpkg-query -W -f='${Status}' php 2>/dev/null | grep -c "ok installed")

if [ "$PHP" -eq 0 ]; then
    echo "Paigaldame php ja vajalikud lisad..."
    sudo apt update
    sudo apt install -y php $PHP_LISAD
    sudo systemctl restart "$TEENUS"
    echo "php on paigaldatud"
elif [ "$PHP" -eq 1 ]; then
    echo "php on juba paigaldatud"
    which php
fi

echo "----------------------------------------"

# 3. Oracle MySQL Serveri kontroll ja paigaldus
MYSQL=$(dpkg-query -W -f='${Status}' mysql-server 2>/dev/null | grep -c "ok installed")

if [ "$MYSQL" -eq 0 ]; then
    echo "MySQL server ei ole paigaldatud."

    while true; do
        read -s -p "Sisesta soovitud MySQL root-parool: " MYSQL_PASS
        echo
        read -s -p "Korda MySQL root-parooli: " MYSQL_PASS2
        echo
        if [ -z "$MYSQL_PASS" ]; then
            echo "Parool ei tohi olla tühi! Proovi uuesti."
        elif [ "$MYSQL_PASS" != "$MYSQL_PASS2" ]; then
            echo "Paroolid ei kattu! Proovi uuesti."
        else
            break
        fi
    done

    echo "Alustan MySQL paigaldamist..."
    sudo dpkg --purge mysql-apt-config 2>/dev/null || true
    sudo rm -f /etc/apt/sources.list.d/mysql.list

    sudo apt update
    sudo apt install -y gnupg ca-certificates debconf-utils wget

    echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.4-lts" | sudo debconf-set-selections
    echo "mysql-apt-config mysql-apt-config/select-tools select Disabled" | sudo debconf-set-selections
    echo "mysql-apt-config mysql-apt-config/select-product select Ok" | sudo debconf-set-selections
    printf "mysql-community-server mysql-community-server/root-pass password %s\n" "$MYSQL_PASS" | sudo debconf-set-selections
    printf "mysql-community-server mysql-community-server/re-root-pass password %s\n" "$MYSQL_PASS" | sudo debconf-set-selections

    wget -O /tmp/mysql-apt-config_0.8.40-1_all.deb https://dev.mysql.com/get/mysql-apt-config_0.8.40-1_all.deb
    sudo DEBIAN_FRONTEND=noninteractive dpkg -i /tmp/mysql-apt-config_0.8.40-1_all.deb
    rm -f /tmp/mysql-apt-config_0.8.40-1_all.deb

    sudo apt update
    if ! sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-server; then
        echo "VIGA: mysql-server paigaldamine ebaõnnestus!"
        exit 1
    fi

    sudo systemctl enable --now mysql

    cat > "$HOME/.my.cnf" << MYEOF
[client]
host=localhost
user=root
password=$MYSQL_PASS
MYEOF
    chmod 600 "$HOME/.my.cnf"
    unset MYSQL_PASS MYSQL_PASS2

    echo "Valmis: Oracle MySQL on installitud ja ~/.my.cnf seadistatud."
    mysql --version
elif [ "$MYSQL" -eq 1 ]; then
    echo "MySQL server on juba paigaldatud."
    systemctl status mysql --no-pager
fi
