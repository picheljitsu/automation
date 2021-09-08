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

