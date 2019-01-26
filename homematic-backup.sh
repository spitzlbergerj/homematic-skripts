#!/bin/bash
# Homematic CCU Backup Script fuer crontab
# Erstellt am 13.03.11 von Danny B.
# Angepasst am 05.08.14 von PaulG4H
# angepasst am 26.01.2019 von spitzlbergerj
#           Backupdatei Name eingeführt anstatt IP-Adresse
#           Löschen alter Backups eingebaut
 
# Parameter
backupdir="/share/CACHEDEV1_DATA/Backup/Auto/homematic/system-backup"
name="homematic-ccu3"
backupanzahl="30"
host="1.1.1.1"
user="user"
password="password"
 
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
wget "http://$host/config/cp_security.cgi?sid=@$sessionid@&action=create_backup" -O $backupdir/$name-backup_$(date +%Y%m%d-%H%M%S).tar.sbk -q >>$run 2>&1
 
# Homematic Logout
wget --post-data '{"method":"Session.logout","params":{"_session_id_":"'$sessionid'"}}' http://$host/api/homematic.cgi -O hm.logout.response -q >>$run 2>&1
 
# temp. Dateien loeschen
rm hm.login.response hm.logout.response >>$run 2>&1

# Alte Sicherungen entfernen
ls -tr $backupdir/$name-backup_* | head -n -$backupanzahl | xargs rm