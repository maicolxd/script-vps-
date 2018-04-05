msc vip script-vps debían 7,8

●  script Auto-intalación :

OpenSSH, port : 22, 143
Dropbear, port : 80, 444
SSL/TLS SSH, port : 443
Squid3, port : 8080, 3128 (limit to IP SSH)
Badvpn : badvpn-udpgw port 7300
Webmin : http://IPVPS:10000/
Nginx : 81
OpenVPN TCP 1194

» menu          : Muestra una lista de comandos disponibles
» user-add      : crear usuarios SSH & OpenVPN
» trial         : crea User prueva
» user-del      : eliminar user SSH & OpenVPN
» user-login    : User online
» user-list     : lista usuarios SSH & OpenVPN
» expdel        : eliminar User exportado
» resvis        : Resetear servicio dropbear, webmin
                 squid3, OpenVPN,Stunnel SSH
» reboot        : Reiniciar VPS
» speedtest     : Speedtest VPS
» info          : info del sistema
» about         : Info del script
» exit          : salir del terminal SSH
~msc vip~
apt-get install ca-certificates
wget https://raw.githubusercontent.com/scriptmsc/scriptmsc/master/debian.sh && chmod +x debian.sh && ./debian.sh
