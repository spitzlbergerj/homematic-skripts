#!/bin/bash
# Homematic CCU Backup Script fuer crontab
# Erstellt am 13.03.11 von Danny B.
# Angepasst am 05.08.14 von PaulG4H
 
# Parameter
backupdir="/share/CACHEDEV1_DATA/Backup/Auto/homematic/system-backup"
host="192.168.178.160"
user="backup"
password="LRydfm5UR23f"
 
############### Es sind keine weiteren Anpassung ab hier Notwendig
 
run=$0.lastrun
 
# Homematic Login
wget --post-data '{"method":"Session.login","params":{"username":"'$user'","password":"'$password'"}}' http://$host/api/homematic.cgi -O hm.login.response -q >$run 2>&1
 
# Login-Pruefung
loginerror=`cat hm.login.response|cut -d "," -f3|awk '{print $2}'`
if [ "$loginerror" != "null}" ]; then
echo "Fehler beim Homematic-Login !"|tee -a $run
cat hm.login.response|grep message|cut -d '"' -f4|tee -a $run
exit 1
fi
sessionid=`cat hm.login.response|cut -d "," -f2|awk '{print $2}'|cut -d '"' -f2`
 
# Backupdatei herunterladen
wget "http://$host/config/cp_security.cgi?sid=@$sessionid@&action=create_backup" -O $backupdir/$host-backup_$(date +%m-%d-%Y).tar.sbk -q >>$run 2>&1
 
# Homematic Logout
wget --post-data '{"method":"Session.logout","params":{"_session_id_":"'$sessionid'"}}' http://$host/api/homematic.cgi -O hm.logout.response -q >>$run 2>&1
 
# temp. Dateien loeschen
rm hm.login.response hm.logout.response >>$run 2>&1