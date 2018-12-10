#!/bin/bash
# Настройка ossec

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
    function addClient() {
        # TODO сделать файл для ossec с для генерации ключей агентов в автоматическом режиме
        
        # Available options:
        #         -h          This help message.
        #         -V          Display OSSEC version.
        #         -l          List available agents.
        #         -e <id>     Extracts key for an agent (Manager only).
        #         -r <id>     Remove an agent. (Manager only).
        #         -i <id>     Import authentication key (Agent only).
        #         -f <file>   Bulk generate client keys from file. (Manager only).
        #                     <file> contains lines in IP,NAME format.
        
        
        
        /var/ossec/bin/manage_agents -f
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
