#!/bin/bash
APT_PACKAGES="jd-gui" "snapd" "python3-pip" 
PY_PACKAGES=
sudo apt-get update -y && sudo apt-get upgrade
sudo apt install -y kali-root-login
apt install -y snapd
apt install python3-pip -y
systemctl enable --now snapd apparmor

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

echo "[*] Restarting sshd service..."
systemctl restart sshd
netstat -tnlup | egrep "tcp\s.+?22\s.+?LISTEN\s" 
M="[+] SSH Daemon"
netstat -tnlup | egrep "tcp\s.+?22\s.+?LISTEN\s" 2>&1 > /dev/null && echo "$M running" || echo "$M failed to restart"

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
echo 'PATH=$PATH:/usr/src/' >> ~/.profile
source ~/.profile

