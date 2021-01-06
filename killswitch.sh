#!/bin/bash

#@SaxxAppeal | Imraan Khan
#Script to pull public IP address. If a change is detected, the qbittorrent-nox service is shut down.


#Start the loop
outerloop="true"
innerloop="true"

#Round and round...
while [ "$outerloop" = "true" ];do

#Pull the public IP before we start
PublicIP=$(curl http://checkip.amazonaws.com)

#Fire up OpenVPN, credentials referenced from pwd file in this directory
echo "Starting OpenVPN..." 
openvpn --config /script/clt_udp.ovpn&
sleep 10
MaskedIP=$(curl http://checkip.amazonaws.com)

#Fire up the QBitTorrent  service
echo "Starting QBitTorrent-nox..."
systemctl start qbittorrent-nox.service

while [ "$innerloop" = "true" ];do

while [ "$MaskedIP" != "$PublicIP" ];do
echo -e "\n$(date)"
echo -e "Masked IP: $MaskedIP"
echo -e "Public IP: $PublicIP\n"

#Debug lines to make sure that info is correct, uncomment to write to the debug file
#echo -e "\n$(date)" >> /script/debug.log
#echo -e "Masked IP: $MaskedIP" >> /script/debug.log
#echo -e "Public IP: $PublicIP\n" >> /script/debug.log

sleep 45
MaskedIP=$(curl http://checkip.amazonaws.com)
done

innerloop="false"
echo "IP ADDRESS CHANGED! Terminating service QBitTorrent-nox..."
systemctl stop qbittorrent-nox.service
echo "Service stopped. Terminating OpenVPN..."
sudo pkill -sigterm -f openvpn
#Write the termination event to the log file, and send an email  to let the sysadmin know!
echo -e $(date): Script terminated. >> /script/log.txt  
ssmtp imraan@khan.gq < /script/error.txt
sleep 5
echo Restarting all......
done
innerloop="true"
done
