#!/bin/bash
# VALUES
clientCount=0
srvCount=0
IPSubNet='192.168.10.0/24'
NTPSrv='N/A'
alddc='N/A'
domenFullName='.example.com'
objName='N/A'
# workFile=0
# time=`date '+%F-%H-%M'`
myRegexp=[1-9,0]{1,3}[.][1-9,0]{1,3}[.][1-9,0]{1,3}[.]
ID=1

function makeAnswerFile {
    function enterValues {
        clear
        read -p  "Введите условное обозначение объекта на латинице: " objName
        # реализовать проверку на латиницу
        # if($objName != [a-z,A-Z])
        # Создаем файл ответов с именем объекта и датой
        clear
        read -p  "Введите количество клиентов на объекте [$clientCount]: " clientCount
        if ($clientCount==' ')
        then
            clientCount=0
        fi
        clear
        read -p  "Введите количество серверов на объекте [$srvCount]: " srvCount
        clear
        read -p  "Задайте IP адресацию сети [$IPSubNet]: " IPSubNet
        clear
        read -p  "Введите краткое имя сервера синхронизации времени [$NTPSrv]: " NTPSrv
        clear
        read -p  "Введите имя контроллера ALD [$alddc]: " alddc
        clear
        read -p  "Введите полное название домена [$domenFullName]: " domenFullName
        showValues
    }
    function showValues {
        clear
        while :
        do
            echo "Вы указали следующие данные:"
            echo "Условное обозначение объекта на латинице - $objName"
            echo "Количество клиентов на объекте - $clientCount"
            echo "Количество серверов на объекте - $srvCount"
            echo "Задана следующая IP адресация сети - $IPSubNet"
            echo "Краткое имя сервера синхронизации времени - $NTPSrv"
            echo "Имя контроллера ALD - $alddc"
            echo "Полное название домена - $domenFullName"
            echo
            read -p "Введенная информация корректна? (y|n)" answer
            
            case $answer in
                [Yy])
                    # date '+%F-%H-%M'>curDate
                    # filename='. ./answerfile_'$objName'_'$curDate''
                    filename='./answerfile_'$objName''
                    # myTime=date
                    
                    # workFile=$filename
                    awk 'BEGIN {printf "Общая информация представлена ниже:\n\nУсловное обозначение объекта на латинице '$objName'\nВремя составления '$myTime'\n\nКоличество клиентов на объекте '$clientCount'\nКоличество серверов на объекте '$srvCount'\nЗадана следующая IP адресация сети '$IPSubNet'\nКраткое имя сервера синхронизации времени '$NTPSrv'\nИмя контроллера ALD '$alddc'\nПолное название домена '$domenFullName'\n" }' >> $filename  #/tmp/tempf.tmp; mv /tmp/tempf.tmp
                    # регулярное выражение, если нет точки в начале - ставит
                    initClient
                    initSRV
                    exit
                ;;
                [Nn]) enterValues;;
                * )
                    clear
                    echo "Пожалуйста, выберите один из вариантов: [Y]es или [N]o."
                    echo
                echo ;;
            esac
        done
    }
    function initClient {
        clear
        while :
        do
            read -p  "Названия Клиентов типовые? (y|n) " answer
            case $answer in
                [Yy])
                    read -p  "Введите основу типового имени (основа-arm дополнение-1): " armName
                    clear
                    read -p  "Введите начальное значение IP для определения адреса(1-255): " armIP
                    [[ $IPSubNet =~ $myRegexp ]]
                    sed -i '$a\\nСписок клиентов:\n' $filename;
                    for (( i=0 ; i <= $clientCount ; i++))
                    {
                        sed -i '$a\ID='$ID' ROLE=CLIENT HOSTNAME='$armName$i' IP='$BASH_REMATCH$armIP' NTPsrv='$NTPSrv' ALD_Contrl='$alddc'' $filename;
                        armIP=$[armIP+1]
                        ID=$[ID+1]
                    }
                    break
                    
                ;;
                [Nn])
                    for (( i=0 ; i < $clientCount ; i++))
                    {
                        sed -i '$a\\nСписок клиентов:\n' $filename;
                        for (( i=0 ; i <= $clientCount ; i++))
                        {
                            read -p  "Введите имя для АРМ c ID '$ID' (нижн.рег+латиница): " armName
                            read -p  "Введите имя для АРМ c IP: " localARMIP_nonauto
                            sed -i '$a\ID='$ID' ROLE=CLIENT HOSTNAME='$armName' IP='$localARMIP_nonauto' NTPsrv='$NTPSrv' ALD_Contrl='$alddc'' $filename;
                            ID=$[ID+1]
                        }
                    }
                    break
                ;;
                * )
                    clear
                    echo "Пожалуйста, выберите один из вариантов: [Y]es или [N]o."
                    echo
                echo ;;
            esac
        done
    }
    # нет - цикл по количеству клиентов в АС
    function initSRV {
        read -p  "Названия Серверов типовые?: " answer
        clear
        while :
        do
            case $answer in
                [Yy])
                    read -p  "Введите основу типового имени (основа-srv дополнение-1): " srvName
                    read -p  "Введите начальное значение IP для определения адреса: " srvIP
                    [[ $IPSubNet =~ $myRegexp ]]
                    sed -i '$a\\nСписок серверов:\n' $filename;
                    for (( i=0 ; i < $srvCount ; i++))
                    {
                        sed -i '$a\ID='$ID' ROLE=SERVER HOSTNAME='$srvName$i' IP='$BASH_REMATCH$srvIP' NTPsrv='$NTPSrv' ALD_Contrl='$alddc'' $filename;
                        srvIP=$[srvIP+1]
                        ID=$[ID+1]
                    }
                    break
                ;;
                [Nn])
                    for (( i=0 ; i < $srvCount ; i++))
                    {
                        read -p  "Введите имя для АРМ c ID '$ID' (нижн.рег+латиница)" armName
                        read -p  "Введите имя для АРМ c IP" localSRVIP_nonauto
                        sed -i '$a\\nСписок серверов:\n' $filename;
                        for (( i=0 ; i < $srvCount ; i++))
                        {
                            sed -i'$a\ID='$ID' ROLE=SERVER HOSTNAME='$srvName' IP='$localSRVIP_nonauto' NTPsrv='$NTPSrv' ALD_Contrl='$alddc'' $filename;
                            srvIP=$[srvIP+1]
                            ID=$[ID+1]
                        }
                    }
                    break
                ;;
                * )
                    clear
                    echo "Пожалуйста, выберите один из вариантов: [Y]es или [N]o."
                    echo
                echo ;;
            esac
        done
    }
    enterValues
}
# Другие настройки
clear
echo "1.старт"
# echo "2.Добавление клиентов в ossec"
# echo "3.Удаление ossec"
# # echo "4.initKES8"
echo "4.Выход"
read -p "Введите число: " answer
case $answer in
    1) echo "СТАРТ...";makeAnswerFile;;
    # 2) echo "Добавление клиентов в ossec...";Ossec_addClient;;
    # 3) echo "Удаление ossec...";apt-get purge ossec-hids-server ossec-hids-agent ossec-web;;
    # # 4) echo "3";menuLv2_Srv;;
    # # 4) echo "4";initKES8;;
    4) echo "Goodbye.";exit;;
    * ) echo "Пожалуйста выберите один из вариантов и введите его номер.";;
esac
# awk 'BEGIN {print "Общая информация представлена ниже:'$\nIP адресация:\nСервер NTP:\nСервер ALD:\nSpecification:\n"}' answerfile
