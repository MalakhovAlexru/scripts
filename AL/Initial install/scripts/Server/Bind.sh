#!/bin/bash
# Настройка bind

# while read hostName
# do echo "PrevName is '$hostName' copied"
# prevHostName=$hostName
# done < /etc/hostname
# echo "$prevHostName"

# read -p "Введите название домена: " domenName
# echo "$domenName"

function bindSettUp_zones() {
    # Делаем БЭК и копируем настройки из шаблона опций
    
    cp /etc/bind/named.conf.options /home/user/scripts/Server/BackUp/named.conf.options
    cp /home/user/scripts/Server/Paterns/bind/named.conf.options /etc/bind/named.conf.options
    # Делаем БЭК и копируем настройки зон
    cp /etc/bind/named.conf.options /home/user/scripts/Server/BackUp/named.conf.local
    cp /home/user/scripts/Server/Paterns/bind/named.conf.local /etc/bind/named.conf.local
    # Делаем каталог для зон и копируем в них настройки для зон (обр и прямой)
    mkdir -p /etc/bind/zones/class
    cp /home/user/scripts/Server/Paterns/bind/flz.class.zone /etc/bind/zones/class/
    cp /home/user/scripts/Server/Paterns/bind/rlz.class.zone /etc/bind/zones/class/
    
    /etc/init.d/bind9 restart
    rndc reload
    
}
