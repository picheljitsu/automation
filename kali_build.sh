#!/bin/bash

sudo apt-get update -y && sudo apt-get upgrade
sudo apt install -y kali-root-login
apt install -y snapd
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



