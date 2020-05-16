#! /bin/bash

#Global Variables
localaddress=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
bold=$(tput bold)
normal=$(tput sgr0)
failed="${bold}Validation Failed! Please correct the errors and try again.${normal}"
checkmark=$(printf '\u2714\n')
crossmark=$(printf '\u274c\n')
setupdir=$PWD/setups/
haproxydownloadfile="haproxy.tar.gz"
luadownloadfile="lua.tar.gz"
releasefile="/etc/redhat-release"
haproxyextracteddir="haproxy/"
luaextracteddir="lua/"
luadir=$setupdir$luaextracteddir
haproxydir=$setupdir$haproxyextracteddir
lualocalinstalldir="/opt/lua"
rsyslogconffile="/etc/rsyslog.d/haproxy.conf"
haproxyinstalledbinary="/usr/local/sbin/haproxy"

#ASCII Artwork
base64 -d <<<"CiDiloTiloTiloTilojilojiloDiloDiloDilpLilojilojilojilojiloggICDilojilojilpEg4paI4paIICDilojilojilojiloQgICAg4paIIAogICDilpLilojiloggIOKWkuKWiOKWiOKWkiAg4paI4paI4paS4paT4paI4paI4paRIOKWiOKWiOKWkiDilojilogg4paA4paIICAg4paIIAogICDilpHilojiloggIOKWkuKWiOKWiOKWkSAg4paI4paI4paS4paS4paI4paI4paA4paA4paI4paI4paR4paT4paI4paIICDiloDilogg4paI4paI4paSCuKWk+KWiOKWiOKWhOKWiOKWiOKWkyDilpLilojiloggICDilojilojilpHilpHilpPilogg4paR4paI4paIIOKWk+KWiOKWiOKWkiAg4paQ4paM4paI4paI4paSCiDilpPilojilojilojilpIgIOKWkSDilojilojilojilojilpPilpLilpHilpHilpPilojilpLilpHilojilojilpPilpLilojilojilpEgICDilpPilojilojilpEKIOKWkuKWk+KWkuKWkuKWkSAg4paRIOKWkuKWkeKWkuKWkeKWkuKWkSAg4paSIOKWkeKWkeKWkuKWkeKWkuKWkSDilpLilpEgICDilpIg4paSIAog4paSIOKWkeKWkuKWkSAgICDilpEg4paSIOKWkuKWkSAg4paSIOKWkeKWkuKWkSDilpHilpEg4paR4paRICAg4paRIOKWkuKWkQog4paRIOKWkSDilpEgIOKWkSDilpEg4paRIOKWkiAgIOKWkSAg4paR4paRIOKWkSAgIOKWkSAgIOKWkSDilpEgCiDilpEgICDilpEgICAgICDilpEg4paRICAg4paRICDilpEgIOKWkSAgICAgICAgIOKWkSAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCg=="
sleep 1
echo "Initializing..."
sleep 3

#Starting Counter
start=`date +%s`

#Script Begins
trap 'err_func $LINENO $?' ERR

#Trap Function to Call Exit
err_func() {
    echo "====> There was a Critical Error at this stage in the Script. Please do no attempt to re-run, contact your administrator. <====="
    echo "Command at Line $1 exited with status $2"
    echo "Exiting.."
    exit 1
}

#Directory Cleanup Function
cleanup_func() {
	echo "Cleaning up local directories"
	rm -rf $setupdir
	echo "Cleanup done!"
	sleep 2
}

isinstalled_func() {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

#Exit Function
exit_func() {
	echo $failed
	exit 1
}

echo "${bold}Initiating Validations...${normal}"
sleep 1

#Checking Existing HAProxy Install (Local or Dist.)
if isinstalled_func haproxy; then
	echo "${bold}Existing HAProxy Install Detected via System Repo.${normal} $crossmark"
	exit_func
elif [ -f $haproxyinstalledbinary ]; then
	echo "${bold}Existing HAProxy Install Detected via Local Install.${normal} $crossmark"
	exit_func
else
	echo "No Existing Installation of HAProxy Detected. $checkmark"
fi

#Checking Internet Access
ping google.com -c 2 >/dev/null
if [ "$?" != 0 ]; then
  echo "${bold}There is no Internet Access available on this Server. Please try again later!${normal} $crossmark"
  exit_func
else
  echo "Internet Access available! $checkmark"
fi
sleep 1

#Number of Arguments Check
if [ $# -eq 2 ]; then
    echo "Script is running with necessary arguments. $checkmark"
    sleep 1
else
	echo "${bold}This Script is to be run with exactly TWO arguments. Please re-run with the correct arguments.${normal} $crossmark"
	exit_func
fi

#Argument Value Safekeeping
if [ ${1:0:33} = "https://www.haproxy.org/download/" ]; then
    echo "HAProxy download URL is valid! $checkmark"
    sleep 1
else
	echo "${bold}First argument is not a valid URL.${normal} $crossmark"
	exit_func
fi

if [ ${2:0:24} = "https://www.lua.org/ftp/" ]; then
    echo "LUA download URL is valid! $checkmark"
    sleep 1
else
	echo "${bold}Second argument is not a valid URL.${normal} $crossmark"
	exit_func
fi

#OS Check
grep -q "CentOS Linux release 7" $releasefile
if [ $? = 0 ]; then
    echo "CenOS 7 Detected. $checkmark"
    sleep 1
else
	echo "${bold}This is not CentOS 7. Exiting..${normal} $crossmark"
	exit_func
fi

#Root user check
if [ $EUID -eq 0 ]; then
	echo "User is root. $checkmark"
	sleep 1
else
	echo "${bold}This script must be run as root. Please switch to root and try again.${normal} $crossmark"
	exit_func
fi


echo "${bold}All Validations Succeeded!${normal} $checkmark"
sleep 1
echo "Proceeding..."
sleep 1

echo "${bold}This script is now going to set up HAProxy with the following parameters:${normal}"
echo "${bold}Current Working Directory:${normal} $PWD/"
echo "${bold}HAProxy Source Download URL:${normal} $1"
echo "${bold}LUA Source Download URL:${normal} $2"
read -p "Proceed with the above parameters? Press Y or N: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo "${bold}Proceeding...${normal}"
	sleep 1
else
	echo "${bold}Exited!${normal}"
	exit 1
fi

echo "${bold}Commencing Download of Dependencies...${normal}"
sleep 1

#Environment Preparation for CentOS 7
yum -y install epel-release
yum -y install vim wget curl htop zip unzip net-tools telnet rsyslog gcc openssl-devel readline-devel systemd-devel make pcre-devel
if [ $? -eq 0 ]; then
        echo "${bold}System Dependencies Resolved & Environment Successfully Created.${normal}"
        sleep 1
        echo "${bold}Local IPv4 Address of this instance is:${normal} $localaddress."
        sleep 1
else
        echo "Environment Creation Failed. Some dependencies could not be installed or configured. Please see below"
        tail /var/log/messages
        end=`date +%s`
		runtime=$((end-start))
		echo "Script took $runtime seconds to execute."
        exit 0
fi
sleep 3

#Work Directory Creation & Source Code Download
echo "${bold}Now Creating Working Directory and Downloading Source Code...${normal}"
sleep 1
mkdir -p $setupdir
wget -O $setupdir$haproxydownloadfile $1
wget -O $setupdir$luadownloadfile $2
echo "${bold}Source Code Successfully Downloaded!${normal}"
sleep 1

#Extraction & Compilation
echo "${bold}Initiating Extraction & Compilation Process...${normal}"
sleep 1
echo "Building LUA Locally"
sleep 1
tar -xvzf $setupdir$luadownloadfile -C $setupdir
mv -v "$setupdir"lua-* "$setupdir""$luaextracteddir"
cd $luadir && make INSTALL_TOP=$lualocalinstalldir linux install
echo "${bold}LUA Successfully Complied & Installed locally at: $lualocalinstalldir${normal}"
sleep 1
echo "${bold}Commencing Building & Installing HAProxy System-Wide...${normal}"
sleep 1
tar -xvzf $setupdir$haproxydownloadfile -C $setupdir
mv -v "$setupdir"haproxy-* "$setupdir""$haproxyextracteddir"
cd $haproxydir && make USE_NS=1 USE_TFO=1 USE_OPENSSL=1 USE_ZLIB=1 USE_LUA=1 USE_PCRE=1 USE_SYSTEMD=1 USE_LIBCRYPT=1 USE_THREAD=1 TARGET=linux-glibc LUA_INC=$lualocalinstalldir/include LUA_LIB=$lualocalinstalldir/lib && make install
echo "${bold}HAProxy Successfully Complied and Installed Syestem-Wide${normal}"
sleep 1
echo "${bold}You can check HAProxy build parameters using haproxy -vv after the script finishes.${normal}"
sleep 1
echo "${bold}Initializing Worker & Sock Management${normal}"
sleep 3
mkdir -p /etc/haproxy
mkdir -p /var/lib/haproxy
touch /var/lib/haproxy/stats 
ln -s /usr/local/sbin/haproxy /usr/sbin/haproxy
cd "$haproxydir"contrib/systemd/ && make
cp -vp "$haproxydir"contrib/systemd/haproxy.service /lib/systemd/system/
systemctl daemon-reload
chkconfig haproxy on
useradd -r haproxy
echo "${bold}Creating Empty Config File at:${normal} /etc/haproxy/haproxy.cfg"
touch /etc/haproxy/haproxy.cfg
echo "Done!"
echo "${bold}Housekeeping Done!${normal}"
sleep 2

#Enabling Logging
echo "${bold}Setting up Logging via Rsyslog...${normal}"
sleep 2
cat >$rsyslogconffile <<"EOL"
# Collect log with UDP
$ModLoad imudp
$UDPServerAddress 127.0.0.1
$UDPServerRun 514

# Creating separate log files based on the severity
local0.* /var/log/haproxy-traffic.log
local0.notice /var/log/haproxy-admin.log
EOL
echo "${bold}Rsyslog Configration File Created at:{normal} $rsyslogconffile"
sleep 1
echo "Restarting Rsyslog Daemon"
systemctl restart rsyslog
echo "Done!"
sleep 1

#Stopping Counter
end=`date +%s`
runtime=$((end-start))

echo "${bold}Script Successfully Finished${normal}"
base64 -d <<<"CuKWiOKWiOKWiOKWiOKWiOKWiOKWiOKVl+KWiOKWiOKVl+KWiOKWiOKWiOKVlyAgIOKWiOKWiOKVl+KWiOKWiOKVl+KWiOKWiOKWiOKWiOKWiOKWiOKWiOKVl+KWiOKWiOKVlyAg4paI4paI4pWX4paI4paI4pWXICAgICAgIOKWiOKWiOKVlyAK4paI4paI4pWU4pWQ4pWQ4pWQ4pWQ4pWd4paI4paI4pWR4paI4paI4paI4paI4pWXICDilojilojilZHilojilojilZHilojilojilZTilZDilZDilZDilZDilZ3ilojilojilZEgIOKWiOKWiOKVkeKWiOKWiOKVkSAgICDilojilojilZfilZrilojilojilZcK4paI4paI4paI4paI4paI4pWXICDilojilojilZHilojilojilZTilojilojilZcg4paI4paI4pWR4paI4paI4pWR4paI4paI4paI4paI4paI4paI4paI4pWX4paI4paI4paI4paI4paI4paI4paI4pWR4paI4paI4pWRICAgIOKVmuKVkOKVnSDilojilojilZEK4paI4paI4pWU4pWQ4pWQ4pWdICDilojilojilZHilojilojilZHilZrilojilojilZfilojilojilZHilojilojilZHilZrilZDilZDilZDilZDilojilojilZHilojilojilZTilZDilZDilojilojilZHilZrilZDilZ0gICAg4paI4paI4pWXIOKWiOKWiOKVkQrilojilojilZEgICAgIOKWiOKWiOKVkeKWiOKWiOKVkSDilZrilojilojilojilojilZHilojilojilZHilojilojilojilojilojilojilojilZHilojilojilZEgIOKWiOKWiOKVkeKWiOKWiOKVlyAgICDilZrilZDilZ3ilojilojilZTilZ0K4pWa4pWQ4pWdICAgICDilZrilZDilZ3ilZrilZDilZ0gIOKVmuKVkOKVkOKVkOKVneKVmuKVkOKVneKVmuKVkOKVkOKVkOKVkOKVkOKVkOKVneKVmuKVkOKVnSAg4pWa4pWQ4pWd4pWa4pWQ4pWdICAgICAgIOKVmuKVkOKVnSAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCg=="
echo "Script took ${bold}$runtime${normal} seconds to execute."
sleep 3

#Calling Cleanup
trap cleanup_func EXIT
