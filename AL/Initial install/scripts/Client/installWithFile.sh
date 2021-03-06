#!/bin/bash

# Определеине переменных
# Главная команда скрипта

# Подключение модульной архитектуры
# . ./path/to/module


# меню для клиента (2.)
function menuLv2_Client() {
    clear
    echo "1.Установка программ"
    echo "2.Настройка конфигурационных файлов (ntp,hosts,hostname,ossec)"
    echo "3.Настройка static interface"
    echo "4.Настройка dhcp interface"
    echo "5.выход"
    read -p "Введите число: " answer
    case $answer in
        1)
            echo "Установка программ..."
            installPO_Client
        ;;
        2)
            echo "Настройка конфигурационных файлов..."
            startCommand_client_2
        ;;
        3)
            echo "Настройка static interface..."
            settUPnetwork_local
        ;;
        4)
            echo "Настройка dhcp interface..."
            settUPnetwork_dhcp
        ;;
        5)
            echo "выход"
            exit
        ;;
        *) echo "Пожалуйста выберите один из вариантов и введите его номер." ;;
    esac
}

# меню для сервера (2.)
function menuLv2_Srv() {
    clear
    echo "1.Установка программ"
    echo "2.Настройка конфигурационных файлов (ntp,hosts,hostname,ossec,interfaces)"
    echo "3.выход"
    read -p "Введите число: " answer
    case $answer in
        1)
            echo "Установка программ..."
            installPO_Server
        ;;
        2)
            echo "Настройка конфигурационных файлов (ntp,hosts,hostname,ossec,interfaces)..."
            startCommand_srv_2
        ;;
        3)
            echo "выход"
            exit
        ;;
        *) echo "Пожалуйста выберите один из вариантов и введите его номер." ;;
    esac
}

function startCommand_client_2() {
    #searchAndBackUP_Files
    chngName
}

function startCommand_srv_2() {
    chngName
    bindSettUp_zones
    ntpSettUp
    settUPnetwork_local
}

function chngName() {
    cp /etc/hosts /root/scripts/Client/BackUP/hosts
    cp /root/scripts/Client/Paterns/hosts /etc/hosts
    cp /etc/hostname /root/scripts/Client/BackUP/hostname
    cp /root/scripts/Client/Paterns/hostname /etc/hostname
    cp /etc/cron.d/ntpdate /root/scripts/Client/BackUP/ntpdate
    cp /root/scripts/Client/Paterns/ntpdate /etc/cron.d/ntpdate
    # while read hostName
    # do echo "PrevName is '$hostName' copied"
    # prevHostName=$hostName
    # done < /etc/hostname
    # echo "$prevHostName"
    read -p "Введите новый IP (192.168.1.1) : " newHostIP
    echo "$newHostIP"
    # реализовать проверку IP и имени
    read -p "Введите новое имя для системы (example): " newHostName
    echo "$newHostName"
    read -p "Введите название домена (.example.com) : " domainName
    echo "$domainName"
    read -p "Введите имя сервера NTP (serverName) : " serverNTP
    echo "$serverNTP"
    fullNameHost="$newHostName$domainName"
    fullNameNTP="$serverNTP$domainName"
    sed -i 's/127.0.1.1/'$newHostIP'/' /etc/hosts
    sed -i 's/astra/'$fullNameHost' '$newHostName'/' /etc/hosts
    sed -i 's/astra/'$newHostName'/' /etc/hostname
    sed -i 's/astra/'$fullNameNTP'/' /etc/cron.d/ntpdate
    chmod 755 /etc/cron.d/ntpdate
}

# установка программ (клиент)
function installPO_Client() {
    apt-get install ossec-hids-agent lftp ald-client-common resolvconf
    dpkg -i --force-architecture /root/scripts/distr/kav4fs-astra_8.0.4-312_i386.deb
}

# установка программ (сервер)
function installPO_Server() {
    apt-get install fly-admin-ald-se apache2-doc astrase-fix-ccache libapache-db-perl libapache-dbi-perl libapache-dbilogger-perl libapache-ruby1.8 libapache2-mod-apreq2 libapache2-mod-auth-kerb libapache2-mod-auth-pam libapache2-mod-bw libapache2-mod-encoding libapache2-mod-evasive libapache2-mod-lisp libapache2-mod-perl2 libapache2-mod-perl2-doc libapache2-mod-php5 libapache2-mod-proxy-html libapache2-mod-python libapache2-mod-python-doc libapache2-mod-rpaf libapache2-mod-ruby libapache2-mod-wsgi libapache2-reload-perl libapache2-request-perl libapreq2 libdbi-perl libdevel-symdump-perl libencode-locale-perl libfile-listing-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libiconv-hook1 libio-socket-ssl-perl liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libnet-http-perl libnet-ssleay-perl libonig2 libpython2.6 libqdbm14 libruby1.8 libtimedate-perl liburi-perl libwww-perl libwww-robotrules-perl php5-cli php5-common python-central python2.6 python2.6-minimal ossec-hids-server ossec-web vsftpd fly-admin-ftp ald-server-common ald-admin-common bind9 libapache2-mod-auth-kerb
    dpkg -i --force-architecture /root/scripts/distr/kav4fs-astra_8.0.4-312_i386.deb
}

# удаление программ клиент и сервер
function deletePO() {
    apt-get purge fly-admin-ald-se avahi-daemon ossec-hids-agent ald-client-common ossec-hids-server ossec-web vsftpd fly-admin-ftp ald-server-common ald-admin-common bind9 libapache2-mod-auth-kerb qpat psi fly-sms fly-phone-webbrowser fly-contacts fly-mail thunderbird wvdial fly-dialer fly-qml-dialer easypaint gimp fly-scan fly-photocamera brasero qasmixer guvcview fly-videocamera fly-record vlc vlc-data vlc-plugin-jack vlc-nox vlc-astra vlc-tablet-plugin vlc-plugin-sdl libvlc5 fly-calc fly-hexedit fly-launcher qbat printer-driver-postscript-hp hplip-gui hplip-data printer-driver-hpcups mc mc-data
}

function aptAutoremove_Client {
    # apt-get purge fly-admin-ald-se avahi-daemon ossec-hids-agent ald-client-common ossec-hids-server ossec-web vsftpd fly-admin-ftp ald-server-common ald-admin-common bind9 libapache2-mod-auth-kerb qpat psi fly-sms fly-phone-webbrowser fly-contacts fly-mail thunderbird wvdial fly-dialer fly-qml-dialer easypaint gimp fly-scan fly-photocamera brasero qasmixer guvcview fly-videocamera fly-record vlc vlc-data vlc-plugin-jack vlc-nox vlc-astra vlc-tablet-plugin vlc-plugin-sdl libvlc5 fly-calc fly-hexedit fly-launcher qbat printer-driver-postscript-hp hplip-gui hplip-data printer-driver-hpcups mc	mc-data
    apt-get autoremove
    # apt-get install fly-dm fly-wm fly-run-sumac fly-run juffed fly-admin-power fly-gamma fly-admin-fonts fly-admin-cron flyqt5platformetheme fly-term fly-fm-audit fly-fm-bsign fly-fm-mac fly-shutdown-dialog fly-admin-autostart fly-admin-runlevel fly-brighness fly-doc fly-image fly-fontconfig-settings fly-system-monitor-mac-plugi libflyauth fly-plastique-style fly-alternatives
    # reboot
    
    # apt-get install -f - построение зависимостей установленных пакетов
    apt-get install fly-dm fly-wm fly-alternatives fly-plastique-style fly-system-monitor fly-system-monitor-mac-plugin libfly-system-monitor libflyauth libgtop2-7 libgtop2-common fly-start-panel fly-admin-autostart fly-admin-runlevel fly-shutdown-dialog libnotify-bin fly-fm-audit fly-fm-bsign fly-fm-mac libparsec-aud-qt5-1 fly-term flyqt5platformtheme qt5-style-plugins fly-admin-cron fly-admin-gamma fly-admin-fonts fly-admin-power enca juffed libenca0 libqt5scintilla2-11 libqt5scintilla2-l10n librecode0 fly-run fly-run-sumac lftp
    
    # СЕРВЕР (apache+ftp)
}
function aptAutoremove_Srv {
    apt-get autoremove
    apt-get install apache2-doc astrase-fix-ccache libapache-db-perl libapache-dbi-perl libapache-dbilogger-perl libapache-ruby1.8 libapache2-mod-apreq2 libapache2-mod-auth-kerb libapache2-mod-bw libapache2-mod-encoding libapache2-mod-evasive libapache2-mod-lisp libapache2-mod-perl2 libapache2-mod-perl2-doc libapache2-mod-proxy-html libapache2-mod-python libapache2-mod-python-doc libapache2-mod-rpaf libapache2-mod-ruby libapache2-mod-wsgi libapache2-reload-perl libapache2-request-perl libapreq2 libdbi-perl libdevel-symdump-perl libencode-locale-perl libfile-listing-perl libhtml-parser-perl libhtml-tagset-perl libhtml-tree-perl libhttp-cookies-perl libhttp-date-perl libhttp-message-perl libhttp-negotiate-perl libiconv-hook1 libio-socket-ssl-perl liblwp-mediatypes-perl liblwp-protocol-https-perl libmailtools-perl libnet-http-perl libnet-ssleay-perl libpython2.6 libruby1.8 libtimedate-perl liburi-perl libwww-perl libwww-robotrules-perl python-central python2.6 python2.6-minimal fly-admin-ftp libdb5.1++ vsftpd
    
}

function settUPnetwork_local() {
    cp /etc/network/interfaces /root/scripts/Client/BackUP/interfaces
    cp /root/scripts/Client/Paterns/interfaces /etc/network/interfaces
    read -p "Введите новый IP хоста: " newHostIP
    echo "$newHostIP"
    read -p "Введите новый IP шлюза: " gatewayIP
    echo "$gatewayIP"
    read -p "Введите новый IP dns-сервера: " dnsSrvIP
    echo "$dnsSrvIP"
    # read -p "Введите новый IP dns-сервера: " dnsSrvIP
    # dnsSrvIP=
    # sed -i '11a\dns-nameservers '$dnsSrvIP'' /etc/network/interfaces
    sed -i 's/127.0.1.1/'$newHostIP'/' /etc/network/interfaces
    sed -i 's/127.0.1.2/'$gatewayIP'/' /etc/network/interfaces
    sed -i 's/127.0.1.3/'$dnsSrvIP'/' /etc/network/interfaces
    killall fly-admin-wicd
    rm /etc/xdg/autostart/fly-admin-wicd.desktop
    service wicd stop
    update-rc.d wicd disable
    killall dhclient
    service networking restart
}

function settUPnetwork_dhcp() {
    cp /etc/network/interfaces /root/scripts/Client/BackUP/interfaces
    cp /root/scripts/Client/Paterns/interfaces /etc/network/interfaces
    sed -i '8,$d' /etc/network/interfaces
    sed -i '6a\\nauto eth0\niface eth0 inet dhcp' /etc/network/interfaces
    killall fly-admin-wicd
    rm /etc/xdg/autostart/fly-admin-wicd.desktop
    service wicd stop
    update-rc.d wicd disable
    service networking restart
}

function bindSettUp_zones() {
    # Делаем БЭК и копируем настройки из шаблона опций
    
    cp /etc/bind/named.conf.options /root/scripts/Server/BackUP/named.conf.options
    cp /root/scripts/Server/Paterns/bind/named.conf.options /etc/bind/named.conf.options
    # Делаем БЭК и копируем настройки зон
    cp /etc/bind/named.conf.options /root/scripts/Server/BackUP/named.conf.local
    cp /root/scripts/Server/Paterns/bind/named.conf.local /etc/bind/named.conf.local
    # Делаем каталог для зон и копируем в них настройки для зон (обр и прямой)
    mkdir -p /etc/bind/zones/class
    cp /root/scripts/Server/Paterns/bind/flz.class.zone /etc/bind/zones/class/
    cp /root/scripts/Server/Paterns/bind/rlz.class.zone /etc/bind/zones/class/
    
    /etc/init.d/bind9 restart
    rndc reload
    
}

function ntpSettUp() {
    # Делаем БЭК и копируем настройки из шаблона опций
    cp /etc/ntp.conf /root/scripts/Server/BackUP/ntp.conf
    cp /root/scripts/Server/Paterns/ntp/ntp.conf /etc/ntp.conf
    update-rc.d ntp defaults
}

###   OSSEC

function initOssec_server() {
    
    mkdir -p /var/remote_logs
    setfacl -d -m u:ossec:rx /var/remote_logs/
    setfacl -R -m u:ossec:rx /var/remote_logs/
    
    cp /var/ossec/etc/10-ossec-syslog.conf /etc/rsyslog.d/
    service rsyslog restart
    
    cp /root/scripts/Server/Paterns/ossec/ossec.conf /var/ossec/etc/ossec.conf
    cp /root/scripts/Server/Paterns/ossec/ossec_audit_send.sh /var/ossec/bin/ossec_audit_send.sh
    
    /etc/init.d/ossec-hids-server restart
    
    cp /root/scripts/Server/Paterns/ossec/rsyslog.conf /etc/rsyslog.conf
    read -p "Введите полное имя сервера ossec на который будут пересылаться записи (ossec.example.com): " ossecSRV
    echo "$ossecSRV"
    
    sed -i '/ASTRA.DOMAIN.LOCAL/s/ASTRA.DOMAIN.LOCAL/'$ossecSRV'/' /etc/rsyslog.conf
    
    service rsyslog restart
    
    # Все агентские машины должны быть добавлены на сервере через
    # интерактивную команду /var/ossec/bin/manage_agents всех агентов,
    # указав их имя и IP-адрес и экспортировать ключ.
    function Ossec_addClient() {
        /var/ossec/bin/manage_agents
    }
}

function initWeb() {
    #     астройка пакета ossec-web осуществляется на сервере.
    # Дать права для пользователя audit-user к файлам сервиса ossec и web-интерфейсу:
    # создаем пользователя
    adduser audit-user
    
    # назначаем права
    setfacl -R -m u:audit-user:rwx /var/www/ossec/
    setfacl -dR -m u:audit-user:rwx /var/www/ossec/
    setfacl -m u:audit-user:rx /var/ossec/
    setfacl -m u:audit-user:rx /var/ossec/bin/
    setfacl -m u:audit-user:rx /var/ossec/bin/manage_agents
    setfacl -m u:audit-user:rx /var/ossec/bin/agent_control
    setfacl -R -m u:audit-user:rx /var/ossec/rules/
    
    setfacl -R -m u:www-data:rx /var/www/ossec/
    setfacl -dR -m u:www-data:rx /var/www/ossec/
}

function initOssec_client() {
    cp /var/ossec/etc/ossec.conf /root/scripts/Client/BackUP/ossec.conf
    cp /var/ossec/bin/ossec_audit_send.sh /root/scripts/Client/BackUP/ossec_audit_send.sh
    
    cp /root/scripts/Client/Paterns/ossec/ossec.conf /var/ossec/etc/ossec.conf
    cp /root/scripts/Client/Paterns/ossec/ossec_audit_send.sh /var/ossec/bin/ossec_audit_send.sh
    
    read -p "Введите полное имя сервера ossec на который будут пересылаться записи (ossec.example.com): " ossecSRV
    echo "$ossecSRV"
    sed -i '$a\\n*.* @@'$ossecSRV'\n$SystemLogRateLimitInterval 2\n$SystemLogRateLimitBurst 50000' /etc/rsyslog.conf
    
    service rsyslog restart
    
    /var/ossec/bin/manage_agents
    
    /etc/init.d/ossec-hids-agent restart
}

function setUpOSSEC() {
    clear
    echo "1.Настройка ossec (сервер)"
    echo "2.Добавление клиентов в ossec"
    echo "3.Удаление ossec"
    # echo "4.initKES8"
    echo "4.Выход"
    read -p "Введите число: " answer
    case $answer in
        1)
            echo "Настройка ossec (сервер)..."
            initOssec_server initWeb
        ;;
        2)
            echo "Добавление клиентов в ossec..."
            Ossec_addClient
        ;;
        3)
            echo "Удаление ossec..."
            apt-get purge ossec-hids-server ossec-hids-agent ossec-web
        ;;
        # 4) echo "3";menuLv2_Srv;;
        # 4) echo "4";initKES8;;
        4)
            echo "Goodbye."
            exit
        ;;
        *) echo "Пожалуйста выберите один из вариантов и введите его номер." ;;
    esac
}

### KAV4FS

function deleteKES8() {
    dpkg --purge kav4fs-astra
}
# инициализация КЕС
function start_script() {
    /opt/kaspersky/kav4fs/bin/kav4fs-setup.pl
    
    # /opt/kaspersky/kav4fs/bin/kav4fs-control --get-task-list
    /opt/kaspersky/kav4fs/bin/kav4fs-control --set-settings 6 --file /root/scripts/confs/KAV/kav_Upd
    /opt/kaspersky/kav4fs/bin/kav4fs-control --create-task fullChk --use-task-type ODS --file /root/scripts/confs/KAV/kav_fullChk
    /opt/kaspersky/kav4fs/bin/kav4fs-control --create-task fastChk --use-task-type ODS --file /root/scripts/confs/KAV/kav_fastChk
    
    # запуск задачи защиты в реальном времени
    /opt/kaspersky/kav4fs/bin/kav4fs-control --start-task 8
    
}
function settUpKES() {
    clear
    echo "1.Настройка скрипта"
    echo "2.Удаление антивируса"
    # echo "3.Настройка сервера"
    # echo "4.initKES8"
    echo "3.Выход"
    read -p "Введите число: " answer
    case $answer in
        1)
            echo "Настройка скрипта..."
            start_script
        ;;
        2)
            echo "Удаление антивируса..."
            deleteKES8
        ;;
        # 3) echo "3";menuLv2_Srv;;
        # 4) echo "4";initKES8;;
        3)
            echo "Goodbye."
            exit
        ;;
        *) echo "Пожалуйста выберите один из вариантов и введите его номер." ;;
    esac
}

# основное меню
clear
echo "1.Удаление программ"
echo "2.Удаление зависимостей и установка ряда программ"
echo "3.Настройка клиента"
echo "4.Настройка сервера"
echo "5.Параметры настройки антивируса (KES4FS_astra)"
echo "6.Настройка OSSEC"
echo "7.выход"
read -p "Введите число: " answer
case $answer in
    1)
        echo "1"
        deletePO
    ;;
    2)
        echo "1"
        aptAutoremove_Client
    ;;
    3)
        echo "2"
        menuLv2_Client
    ;;
    4)
        echo "3"
        menuLv2_Srv
    ;;
    5)
        echo "4"
        settUpKES
    ;;
    6)
        echo "5"
        setUpOSSEC
    ;;
    7)
        echo "Goodbye."
        exit
    ;;
    *) echo "Пожалуйста выберите один из вариантов и введите его номер." ;;
esac
