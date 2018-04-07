#!/bin/bash
# ~sivoi~
# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install wget and curl
apt-get update;apt-get -y install wget curl;

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
service ssh restart

# set repo
wget -O /etc/apt/sources.list "https://raw.githubusercontent.com/kholizsivoi/script/master/sources.list.debian7"
wget "http://www.dotdeb.org/dotdeb.gpg"
cat dotdeb.gpg | apt-key add -;rm dotdeb.gpg
sh -c 'echo "deb http://download.webmin.com/download/repository sarge contrib" > /etc/apt/sources.list.d/webmin.list'
wget -qO - http://www.webmin.com/jcameron-key.asc | apt-key add -

# update
apt-get update

# install webserver
apt-get -y install nginx
apt-get install figlet -y

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

# install neofetch
echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch

echo "deb http://dl.bintray.com/dawidd6/neofetch jessie main" | tee -a /etc/apt/sources.list
curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray"| apt-key add -
apt-get update
apt-get install neofetch
echo "clear" >> .bash_profile
echo "neofetch" >> .bash_profile

# install webserver
cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/kholizsivoi/script/master/nginx.conf"
mkdir -p /home/vps/public_html
echo "<pre>~sivoi~</pre>" > /home/vps/public_html/index.html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/kholizsivoi/script/master/vps.conf"
service nginx restart

# install openvpn
wget -O /etc/openvpn/openvpn.tar "https://raw.githubusercontent.com/kholizsivoi/script/master/vpn.tar"
cd /etc/openvpn/
tar xf openvpn.tar
rm -f /etc/openvpn/openvpn.tar
wget -O /etc/openvpn/1194.conf "https://raw.githubusercontent.com/maicolxd/script/master/1194.conf"
service openvpn restart
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -t nat -I POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
iptables-save > /etc/iptables_set.conf
wget -O /etc/network/if-up.d/iptables "https://raw.githubusercontent.com/kholizsivoi/script/master/iptables"
chmod +x /etc/network/if-up.d/iptables
service openvpn restart

# konfigurasi openvpn
cd /etc/openvpn/
wget -O /etc/openvpn/client.ovpn "https://raw.githubusercontent.com/maicolxd/script/master/client-1194.conf"
sed -i $MYIP2 /etc/openvpn/client.ovpn;
cp client.ovpn /home/vps/public_html/

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/kholizsivoi/script/master/badvpn-udpgw"
if [ "$OS" == "x86_64" ]; then
  wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/kholizsivoi/script/master/badvpn-udpgw64"
fi
sed -i '$ i\screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300' /etc/rc.local
chmod +x /usr/bin/badvpn-udpgw
screen -AmdS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300

# setting port ssh
cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 53' /etc/ssh/sshd_config
service ssh restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 443 -p 80"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# install dropbear 2017
cd
wget https://raw.githubusercontent.com/kholizsivoi/script/master/dropbear-2017.75.tar.bz2
apt-get install zlib1g-dev
bzip2 -cd dropbear-2017.75.tar.bz2  | tar xvf -
cd dropbear-2017.75
./configure
make && make install
mv /usr/sbin/dropbear /usr/sbin/dropbear1
ln /usr/local/sbin/dropbear /usr/sbin/dropbear
service dropbear restart
rm -f /root/dropbear-2017.75.tar.bz2

# install stunnel4
apt-get -y install stunnel4
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/kholizsivoi/stunnel4/master/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/kholizsivoi/stunnel4/master/stunnel.conf"
sed -i $MYIP2 /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# install fail2ban
apt-get -y install fail2ban;
service fail2ban restart

# install squid3
cd
apt-get -y install squid3
wget -O /etc/squid3/squid.conf "https://raw.githubusercontent.com/kholizsivoi/script/master/squid3.conf"
sed -i $MYIP2 /etc/squid3/squid.conf;
service squid3 restart

# install webmin
cd
wget "http://prdownloads.sourceforge.net/webadmin/webmin_1.850_all.deb"
dpkg --install webmin_1.850_all.deb;
apt-get -y -f install;
rm /root/webmin_1.850_all.deb
sed -i 's/ssl=1/ssl=0/g' /etc/webmin/miniserv.conf
service webmin restart

# blockir torrent
iptables -A OUTPUT -p tcp --dport 6881:6889 -j DROP
iptables -A OUTPUT -p udp --dport 1024:65534 -j DROP
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP

# setting banner
rm /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/issue.net"
sed -i 's@#Banner@Banner@g' /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
service ssh restart
service dropbear restart

# download script
cd /usr/bin
wget -O menu "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/menu.sh"
wget -O crear "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/user-add.sh"
wget -O prueva "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/prueva.sh"
wget -O eliminar "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/hapus.sh"
wget -O online "https://raw.githubusercontent.com/maicolxd/script-vps-/master/user-login.sh"
wget -O lista "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/user-list.sh"
wget -O expirados "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/delexp.sh"
wget -O reiniciar "https://raw.githubusercontent.com/maicolxd/script/master/reiniciar.sh"
wget -O velocidad "https://raw.githubusercontent.com/kholizsivoi/script/master/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/info.sh"
wget -O mas "https://raw.githubusercontent.com/maicolxd/script-vps-/mscvip-1/about.sh"

echo "0 0 * * * root /sbin/reboot" > /etc/cron.d/reboot

chmod +x menu
chmod +x crear
chmod +x prueva
chmod +x eliminar
chmod +x online
chmod +x lista
chmod +x reiniciar
chmod +x velocidad
chmod +x info
chmod +x expirados
chmod +x mas

# finishing
cd
chown -R www-data:www-data /home/vps/public_html
service nginx start
service openvpn restart
service cron restart
service ssh restart
service dropbear restart
service stunnel4 restart
service squid3 restart
service fail2ban restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile
clear

# info
cd
figlet MSC VIP PERU
figlet TU VPS 
figlet FUE 
figlet CONFIGURADO
menu
