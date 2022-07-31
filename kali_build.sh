#!/bin/bash
#add pw spraying https://github.com/byt3bl33d3r/SprayingToolkit.git
#add check for network/internet connectivity

LAST_CWD=`pwd`
LOG_FILE=/tmp/kali_setup_install.log
APT_PACKAGES=(jd-gui snapd python3-pip)
PY_PACKAGES=twint
cd /tmp
THIS_TTY=`/usr/bin/tty`
echo "tty set to $THIS_TTY" >> $LOG_FILE

printf "[+] Logging to $LOG_FILE"
echo "[*] Updating and upgrading..."
sudo apt-get update -y >> $LOG_FILE 2>&1 && sudo apt-get upgrade -y >> $LOG_FILE 2>&1
echo "[+] Done w/ update and upgrade"

echo "[*] Enabling root login..."
sudo apt install -y kali-root-login >> install.log 2>&1
echo "[+] root login enabled"

ROOT_PW='changeme'

while true; do
    CONFIRM_PW=''
    echo "[+] Enter new root password or hit enter to accept default password and continue (default: $ROOT_PW) " 
    read -p INPUT_PW
    if [[ ! -z $INPUT_PW ]]
    then            
        ROOT_PW=$INPUT_PW
    fi   
    echo "[+] Accept new password '$ROOT_PW'? (Y/n) " 
    read CONFIRM_PW
        case $CONFIRM_PW in
            [Yy]*|"" ) echo -e "$ROOT_PW\n$ROOT_PW\n$ROOT_PW" | sudo passwd root; break;;
            [Nn]* ) ;;
            * ) echo "Please answer yes or no.";;
        esac        
done

#fork task to login to desktop once user session killed?
#logout of the session
echo "[*] Logging out of session. Log in as root"
sleep 5s
sudo killall -u `whoami`

#Set root creds
if [ $1 ]; then
  passwd root $1
fi 


echo "[*] Starting package install"
for P in $APT_PACKAGES; do
  echo "[*] $P"
  apt install $P -y >> $LOG_FILE
  echo "[+] Installed package $P"
done

#Set up SSH server login
SSHD=/etc/ssh/sshd_config

echo "[*] Processing ssh daemon rules"
#Back dataz up
cp $SSHD $SSHD.bak
echo "[+] Backed up $SSHD"
#Allow Root Login
O='#PermitRootLogin prohibit-password'
I='PermitRootLogin yes'
egrep -q $O $SSHD && sed -i "s/$O/$I/g" $SSHD && \ 
        echo "[+] Enabled root login" || \
        echo "[-] Failed to enable root login"

#Allow pw auth
O='#PasswordAuthentication yes' 
I='PasswordAuthentication yes'
egrep -q $O $SSHD && sed -i "s/$O/$I/g" $SSHD  && \ 
        echo "[+] Allowed password authentication" || \
        echo "[-] Failed to allow password authentication"

echo "[*] Restarting services..."
systemctl restart ssh >> $LOG_FILE
echo "[+] Restarted sshd"


netstat -tnlup | egrep "tcp\s.+?22\s.+?LISTEN\s" 
M="[+] SSH Daemon"
netstat -tnlup | egrep "tcp\s.+?22\s.+?LISTEN\s" 2>&1 > /dev/null && echo "$M running" || echo "$M failed to restart"

systemctl enable --now snapd apparmor >> $LOG_FILE
echo "[+] Started snapd"

pip3 install twint >> $LOG_FILE

cd /tmp

#https://code.visualstudio.com/docs/setup/linux
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg >> $LOG_FILE
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/ >> $LOG_FILE
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt-get install apt-transport-https >> $LOG_FILE 2>&1
sudo apt-get update >> $LOG_FILE  2>&1
sudo apt-get install code -y >> $LOG_FILE 2>&1

cd $LAST_CWD
LOCAL_SBIN=/usr/local/sbin/
#Set path for custom scripts
echo "[*] Setting custom scripts..."
cp SCRIPTS/* $LOCAL_SBIN
echo "[+] Copied scripts to $LOCAL_SBIN"
