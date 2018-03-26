#!/bin/bash

BACKUPTIME=`date +%d-%b-%y` #get the current date

DESTINATION=/mnt/new/Daily_VM_Backups/$BACKUPTIME.tar.gz #create a backup file using the current date in it's name

SOURCEFOLDER=/mnt/new/VirtualBox_VMs/  #the folder that contains the files that we want to backup

tar -cpzf $DESTINATION $SOURCEFOLDER #create the backup
