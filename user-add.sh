#!/bin/bash

read -p "Username : " Login
read -p "Password : " Pass
read -p "Expira (VPS): " 

IP=`dig +short myip.opendns.com @resolver1.opendns.com`
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null
echo -e ""
echo -e "====Informacion SSH ===="
echo -e "Host: $IP" 
echo -e "Port OpenSSH   : 22,53"
echo -e "Port Dropbear  : 80,444"
echo -e "Port SSL/TLS   : 443"
echo -e "Port Squid     : 8080,3128"
echo -e "Config OpenVPN (TCP 1194): http://$IP:81/client.ovpn"
echo -e "Username: $Login "
echo -e "Password: $Pass"
echo -e "-----------------------------"
echo -e "grupo vip: $exp"
echo -e "============================="
echo -e "~mscvip~"
