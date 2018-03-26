#!/bin/bash

location1=/mnt/new/Daily_VM_Backups/
location2=/media/qm/Elements/Backups/VM_Backups/

find $location1 -mtime +3 -type f -delete
find $location2 -mtime +3 -type f -delete
