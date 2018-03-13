#! /bin/bash

#Global Variables
localaddress=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
FILE="/usr/lib/systemd/system/glancesweb.service"


##LAMPP Install
#echo "Initiating LAMPP Install"
#apt-get install lamp-server^
#if [ $? -eq 0 ]; then
#	echo "LAMPP Installation Succeeded"
#else
#	echo "LAMPP Installation Error, Please Check Logs and Re-Run the Script"
#	exit 0
#fi



#Glances install
apt -y install glances python-bottle
if [ $? -eq 0 ]; then
        echo "Glances & Bottle Setup Succeeded"
else
        echo "Glances/Bottle Setup FAILED.. Please check Logs and Re-Run the Script"
        exit 0
fi

#UFW Config
echo "Diabling UFW..."
ufw disable
if [ $? -eq 0 ]; then
        echo "UFW Disabled!"
else
        echo "Unable to Disable UFW.. Please Check Logs and Re-Run the Script"
        exit 0
fi

#Glances File Creation
mkdir /usr/lib/systemd/system/
touch /usr/lib/systemd/system/glancesweb.service



#Glances Service Creation
/bin/cat <<EOM >$FILE
[Unit]
Description = Glances in Web Server Mode
After = network.target
ExecStart = /usr/bin/glances -w -t 5
[Install]
WantedBy = multi-user.target
EOM



#Glances Service Setup
systemctl enable glancesweb.service
systemctl start glancesweb.service
if [ $? -eq 0 ]; then
	echo "Glances Setup Completed.. Point Any Browser in the Local Network to $localaddress":"61208"
else
        echo "Glances Service Could Not be Started due to an Error.. Please Run systemctl status glancesweb.service to Rectify the problem.. Do not Re-Run the Script After That.. Troubleshoot the Service Manually!"
        exit 0
fi
