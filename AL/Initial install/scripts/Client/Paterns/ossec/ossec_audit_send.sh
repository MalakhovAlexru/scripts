#!/bin/sh
#Parsec logs sending  quick start. Run in background.
SELF=$(basename $0)
#Check for another copy of itself.
for i in $(pgrep -U "$UID" -f "$SELF"); do
	[ $i != $$ ] && exit 1
	done


#script for parsing parselog files and sending of server

logfile=(/var/log/parsec/user.mlog /var/log/parsec/kernel.mlog)
ossectimefile='/var/ossec/etc/lasttimefile'
[ -f $ossectimefile ] || touch $ossectimefile
lasttime=`cat $ossectimefile`
   if [ $lasttime = " " ];
       then lasttime=`date +%y%m%d` #1 day logging
   fi
while true
do
    currenttime=`date +%y%m%d%H%M%S`
    lasttime=`cat $ossectimefile`
    timerange="$lasttime-$currenttime"
    for f in ${logfile[*]}
    do
        ###if you want to filter parlog messages put the command here###

        parselog $f -t$timerange -l -s
        #parselog --events connect --status success --arg0 ssh -t$timerange --syslog $f #ssh event
    done
    #echo $((currenttime - 1)) > $ossectimefile
    echo $currenttime > $ossectimefile
    sleep 10
done
