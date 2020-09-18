# ovpn-killswitch
Spawns OpenVPN connection and monitors external IP for changes. If a change is detected, qbittorrent-nox service is shut down and the SysAdmin is notified.

-Dependencies-

1) qBitTorrent-nox installed and configured as a service named qbittorrent-nox
2) ssmtp installed and configured to send email from command line. You can use an internal mail server if one is configured on this serever, or you can connect to an SMTP server of your choice.

-Killswitch.sh-

This is the script that actually does all of the work.

error.txt-

This is the subject and body of the email that is automatically sent by the server should the killswitch engage.

-pass.txt-

This is where your OpenVPN user name and password are stored in plain text. These are usually NOT your user name and password for your VPN service, if you pay for one!! The OpenVPN credentials are a string of letters and numbers, both for the user name and the password.

