# homematic-scripts
scripts and tools for my homematic installation

## homematic-backup.sh
This script is regularly started on a NAS or another linux machine via crontab. The script executes a system backup on the Homematic ccu and saves the backup file on the executing computer. Finally, old backup files are deleted up to the specified number of backups.

**Configuration within script**  
    backupdir="/homematic/system-backup"   
    name="homematic-ccu3"  
    number of backups="30"  
    host="1.1.1.1"  
    user="user"  
    password="password"  
