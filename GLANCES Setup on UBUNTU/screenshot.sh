#! /bin/bash

#Global Variables
localaddress=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
FILE="/usr/lib/systemd/system/glancesweb.service"
package1=nmap
package2=cutycapt
curr_date_time=`date +%m-%d-%Y`
dir=/home/qm/Documents/Screenshots/


#Preliminary Package Check & Install
dpkg -s $package_name &> /dev/null
if [ $? -eq 0 ]; then
    echo "$package_name is already installed" 
else
    apt -y install $package1
fi

dpkg -s $package_name &> /dev/null
if [ $? -eq 0 ]; then
    echo "$package_name2 is already installed" 
else
    apt -y install $package2
fi

#nmap Dump to Local File
echo "Generating IP List (Dumping to Local File)"
nmap -sn 192.168.0.0/24 | egrep "scan report" | awk '{print $5}' 2>&1 | tee $curr_date_time.txt
echo "IP List Dumped to $curr_date_time.txt"

#nmap Retreival from Local File & Screenshot Generation
echo "Initiating Screenshot Dump to -> $dir"
mkdir -p $dir
while IFS='' read -r line || [[ -n "$line" ]]; do
    cutycapt --url=$line:61208 --out=$dir$line.png --max-wait=500
done < "$curr_date_time.txt"


echo "Cleaning Temporary Local Files"
rm $curr_date_time.txt
echo "Script Completed Successfully"
