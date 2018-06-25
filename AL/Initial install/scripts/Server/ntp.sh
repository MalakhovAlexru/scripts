#!/bin/bash
# Настройка ntp

function ntpSettUp() {
    # Делаем БЭК и копируем настройки из шаблона опций
    cp /etc/ntp.conf /home/user/scripts/Server/BackUp/ntp.conf
    cp /home/user/scripts/Server/Paterns/ntp/ntp.conf /etc/ntp.conf
    update-rc.d ntp defaults
}
