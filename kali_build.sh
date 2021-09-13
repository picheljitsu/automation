#!/bin/bash
APT_PACKAGES="jd-gui" "snapd" "python3-pip" 
PY_PACKAGES=twint
cd /tmp
sudo apt-get update -y >> install.log 2>&1 && sudo apt-get upgrade >> install.log 2>&1
sudo apt install -y kali-root-login >> install.log 2>&1

#fork task to login to desktop once user session killed?

#logout of the session
sudo killall -u `whoami`



#Set root creds
if [ $1 ]; then
  passwd root $1
fi 
echo "[*] Starting package install"
for P in $APT_PACKAGES;
  do apt install $P -y >> $P_install.log
  echo "[+] Installed package $P"
done

#Set up SSH server login
SSHD=/etc/ssh/sshd_config

#Back dataz up
cp $SSHD $SSHD.bak

#Allow Root Login
O='#PermitRootLogin prohibit-password'
I='PermitRootLogin yes'
egrep -q $TREX $SSHD && sed -i "s/$O/$I/g"  $SSHD 

#Allow pw auth
O='#PasswordAuthentication yes' 
I='PasswordAuthentication yes'
egrep -q $TREX $SSHD && sed -i "s/$O/$I/g"  $SSHD 

echo "[*] Restarting services..."
systemctl restart sshd
echo "[+] Restarted sshd"


netstat -tnlup | egrep "tcp\s.+?22\s.+?LISTEN\s" 
M="[+] SSH Daemon"
netstat -tnlup | egrep "tcp\s.+?22\s.+?LISTEN\s" 2>&1 > /dev/null && echo "$M running" || echo "$M failed to restart"

systemctl enable --now snapd apparmor
echo "[+] Started snapd"

pip3 install twint 

cd /tmp

#https://code.visualstudio.com/docs/setup/linux
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
apt install apt-transport-https
sudo apt update
sudo apt install code -y

#Set path for custom scripts
echo "[*] Setting custom scripts..."
cp SCRIPTS/* /usr/src/
echo "[+] Copied scripts to /usr/src"
echo 'PATH=$PATH:/usr/src/' >> ~/.profile
source ~/.profile
echo "[+] Added /usr/src to PATH env variable"

