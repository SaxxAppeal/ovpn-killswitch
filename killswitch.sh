#!/bin/bash

#@SaxxAppeal | Imraan Khan
#Script to pull public IP address. If a change is detected, the qbittorrent-nox service is shut down and admin is notified.

#Pull the public IP before we start
PublicIP=$(dig +short myip.opendns.com @resolver1.opendns.com)

#Start the loop
loop="true"

#Fire up OpenVPN, credentials referenced from pwd file in this directory
openvpn cert.ovpn&
sleep 10

#Fire up the QBitTorrent  service
systemctl start qbittorrent-nox.service

#Round and round...
while [ "$loop" = "true" ];do
MaskedIP=$(dig +short myip.opendns.com @resolver1.opendns.com)

if [ $MaskedIP != $PublicIP ]
then
echo -e "\n$(date)"
echo -e "Masked IP: $MaskedIP"
echo -e "Public IP: $PublicIP\n"

sleep 15
else
loop="false"
echo "IP ADDRESS CHANGED! Terminating service qbittorrent-nox"
systemctl stop qbittorrent-nox.service
echo "Service stopped. Terminating..."

#Write the termination event to the log file, and send an email  to let the sysadmin know!
echo -e $(date): Script terminated. > /script/log.txt  

#ssmtp your@email.here < error.txt

fi
done
