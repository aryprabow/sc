#Script By Bowo
#!/bin/bash

if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
if [ -f "/etc/v2ray/domain" ]; then
echo "Script Already Installed"
exit 0
fi
mkdir /var/lib/premium-script;
echo "IP=" >> /var/lib/premium-script/ipvps.conf

# install essential package
apt-get -y install nano iptables dnsutils openvpn screen whois ngrep unzip unrar

install screenfetch
cd
wget -O /usr/bin/screenfetch "https://raw.githubusercontent.com/aryprabow/sc/main/screenfetch"
chmod +x /usr/bin/screenfetch,
echo "clear" >> .profile
echo "screenfetch" >> .profile

# MengInstall SSH
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Indonesia
locality=Indonesia
organization=bowoserver.my.id
organizationalunit=bowoserver.my.id
commonname=bowoserver.my.id
email=akses@bowoserver.my.id

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/aryprabow/sc/main/password"
chmod +x /etc/pam.d/common-password

# go to root
cd

# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END

# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

# install wget and curl
apt -y install wget curl

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl git lsof

# install neofetch
cd
wget -O /usr/bin/neofetch "https://raw.githubusercontent.com/aryprabow/sc/main/neofetch"
chmod +x /usr/bin/neofetch
echo "clear" >> .profile
echo "neofetch" >> .profile

# install webserver
apt -y install nginx
cd
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/aryprabow/sc/main/nginx.conf"
mkdir -p /home/vps/public_html
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/aryprabow/sc/main/vps.conf"
/etc/init.d/nginx restart

# install badvpn
cd
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/aryprabow/sc/main/badvpn-udpgw64"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

# setting port ssh
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config

# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/dropbear restart

# install squid
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/aryprabow/sc/main/squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf

# setting vnstat
apt -y install vnstat
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6

# install stunnel
apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

#[stunnelws]
#accept = 443
#connect = 127.0.0.1:8880

[dropbear]
accept = 445
connect = 127.0.0.1:109

[dropbear]
accept = 990
connect = 127.0.0.1:109

[openvpn]
accept = 992
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

cd
apt-get -y install sslh
#configurasi sslh
wget -O /etc/default/sslh "https://raw.githubusercontent.com/aryprabow/sc/main/sslh-conf"
service sslh restart
/etc/init.d/sslh restart

#OpenVPN
wget https://raw.githubusercontent.com/aryprabow/sc/main/vpn.sh && chmod +x vpn.sh && ./vpn.sh

# install fail2ban
apt -y install fail2ban

# Instal DDOS Flate
if [ -d '/usr/local/ddos' ]; then
	echo; echo; echo "Please un-install the previous version first"
	exit 0
else
	mkdir /usr/local/ddos
fi
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'

# banner /etc/issue.net
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# blockir torrent
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
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# teks berwarna
apt-get -y install ruby
gem install lolcat

# xml parser
#cd
#apt install -y libxml-parser-perl

# banner /etc/issue.net
wget -O /etc/issue.net "https://raw.githubusercontent.com/aryprabow/sc/main/issue.net"
echo "Banner /etc/issue.net" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

# download script
cd /usr/bin
wget -O add-host "https://raw.githubusercontent.com/aryprabow/sc/main/add-host.sh"
wget -O about "https://raw.githubusercontent.com/aryprabow/sc/main/about.sh"
wget -O menu "https://raw.githubusercontent.com/aryprabow/sc/main/menu.sh"
wget -O usernew "https://raw.githubusercontent.com/aryprabow/sc/main/usernew.sh"
wget -O trial "https://raw.githubusercontent.com/aryprabow/sc/main/trial.sh"
wget -O hapus "https://raw.githubusercontent.com/aryprabow/sc/main/hapus.sh"
wget -O member "https://raw.githubusercontent.com/aryprabow/sc/main/member.sh"
wget -O delete "https://raw.githubusercontent.com/aryprabow/sc/main/delete.sh"
wget -O cek "https://raw.githubusercontent.com/aryprabow/sc/main/cek.sh"
wget -O restart "https://raw.githubusercontent.com/aryprabow/sc/main/restart.sh"
wget -O speedtest "https://raw.githubusercontent.com/aryprabow/sc/main/speedtest_cli.py"
wget -O info "https://raw.githubusercontent.com/aryprabow/sc/main/info.sh"
wget -O ram "https://raw.githubusercontent.com/aryprabow/sc/main/ram.sh"
wget -O renew "https://raw.githubusercontent.com/aryprabow/sc/main/renew.sh"
wget -O autokill "https://raw.githubusercontent.com/aryprabow/sc/main/autokill.sh"
wget -O ceklim "https://raw.githubusercontent.com/aryprabow/sc/main/ceklim.sh"
wget -O tendang "https://raw.githubusercontent.com/aryprabow/sc/main/tendang.sh"
wget -O clear-log "https://raw.githubusercontent.com/aryprabow/sc/main/clear-log.sh"
wget -O change-port "https://raw.githubusercontent.com/aryprabow/sc/main/change.sh"
wget -O port-ovpn "https://raw.githubusercontent.com/aryprabow/sc/main/port-ovpn.sh"
wget -O port-ssl "https://raw.githubusercontent.com/aryprabow/sc/main/port-ssl.sh"
wget -O port-wg "https://raw.githubusercontent.com/aryprabow/sc/main/port-wg.sh"
wget -O port-tr "https://raw.githubusercontent.com/aryprabow/sc/main/port-tr.sh"
wget -O port-sstp "https://raw.githubusercontent.com/aryprabow/sc/main/port-sstp.sh"
wget -O port-squid "https://raw.githubusercontent.com/aryprabow/sc/main/port-squid.sh"
wget -O port-ws "https://raw.githubusercontent.com/aryprabow/sc/main/port-ws.sh"
wget -O port-vless "https://raw.githubusercontent.com/aryprabow/sc/main/port-vless.sh"
wget -O wbmn "https://raw.githubusercontent.com/aryprabow/sc/main/webmin.sh"
wget -O xp "https://raw.githubusercontent.com/aryprabow/sc/main/xp.sh"
wget -O bannerku "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/bannerku"
wget -O bbr "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/bbr.sh"
wget -O menu "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/menu.sh"
wget -O trojaan "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/trojaan.sh"
wget -O vleess "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/vleess.sh"
wget -O wgr "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/wgr.sh"
wget -O l2tp "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/l2tp.sh"
wget -O v2raay "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/v2raay.sh"
wget -O ssh "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/ssh.sh"
wget -O sstpp "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/sstpp.sh"
wget -O ssssr "https://raw.githubusercontent.com/aryprabow/sc/main/menu-all/ssssr.sh"
wget -O backup "https://raw.githubusercontent.com/aryprabow/sc/main/backup.sh"
wget -O autobackup "https://raw.githubusercontent.com/aryprabow/sc/main/autobackup.sh"
wget -O rclone "https://raw.githubusercontent.com/aryprabow/sc/main/rclone.conf"
chmod +x add-host
chmod +x script-info
chmod +x menu
chmod +x usernew
chmod +x trial
chmod +x hapus
chmod +x member
chmod +x delete
chmod +x cek
chmod +x restart
chmod +x speedtest
chmod +x info
chmod +x about
chmod +x autokill
chmod +x tendang
chmod +x ceklim
chmod +x ram
chmod +x renew
chmod +x clear-log
chmod +x change-port
chmod +x port-ovpn
chmod +x port-ssl
chmod +x port-wg
chmod +x port-sstp
chmod +x port-tr
chmod +x port-squid
chmod +x port-ws
chmod +x port-vless
chmod +x wbmn
chmod +x clear-log
chmod +x xp
chmod +x bannerku
chmod +x bbr
chmod +x menu
chmod +x trojaan
chmod +x vleess
chmod +x wgr
chmod +x l2tp
chmod +x v2raay
chmod +x ssh
chmod +x sstpp
chmod +x ssssr
echo "0 5 * * * root clear-log && reboot" >> /etc/crontab
echo "0 0 * * * root xp" >> /etc/crontab
# remove unnecessary files
cd
apt autoclean -y
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/cron restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/stunnel4 restart
/etc/init.d/vnstat restart
/etc/init.d/squid restart
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh

# finihsing
clear


mkdir /var/lib/premium-script;
echo "IP=" >> /var/lib/premium-script/ipvps.conf
wget https://raw.githubusercontent.com/aryprabow/sc/main/cf.sh && chmod +x cf.sh && ./cf.sh
#install sstp
wget https://raw.githubusercontent.com/aryprabow/sc/main/sstp.sh && chmod +x sstp.sh && ./sstp.sh
#install ssr
wget https://raw.githubusercontent.com/aryprabow/sc/main/ssr.sh && chmod +x ssr.sh && ./ssr.sh
wget https://raw.githubusercontent.com/aryprabow/sc/main/sodosok.sh && chmod +x sodosok.sh && ./sodosok.sh
#installwg
wget https://raw.githubusercontent.com/aryprabow/sc/main/wg.sh && chmod +x wg.sh && ./wg.sh
#install v2ray
wget https://raw.githubusercontent.com/aryprabow/sc/main/ins-vt.sh && chmod +x ins-vt.sh && ./ins-vt.sh
#install L2TP
wget https://raw.githubusercontent.com/aryprabow/sc/main/ipsec.sh && chmod +x ipsec.sh && ./ipsec.sh
#install WEBSOCKET
wget https://raw.githubusercontent.com/aryprabow/sc/main/edu.sh && chmod +x edu.sh && ./edu.sh
#wget https://raw.githubusercontent.com/aryprabow/sc/main/websocket.sh && chmod +x websocket.sh && ./websocket.sh
wget https://raw.githubusercontent.com/aryprabow/sc/main/websocket-python/websocket.sh && chmod +x websocket.sh && ./websocket.sh
rm -f /root/ssh-vpn.sh
rm -f /root/sstp.sh
rm -f /root/wg.sh
rm -f /root/ss.sh
rm -f /root/ssr.sh
rm -f /root/ins-vt.sh
rm -f /root/ipsec.sh
rm -f /root/set-br.sh
rm -f /root/edu.sh
rm -f /root/websocket.sh
cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://vpnstores.net

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -O /etc/set.sh "https://raw.githubusercontent.com/aryprabow/sc/main/set.sh"
chmod +x /etc/set.sh
history -c
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "==================-Autoscript Premium-============" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "-----------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200, SSL 442"  | tee -a log-install.txt
echo "   - Stunnel4                : 990"  | tee -a log-install.txt
echo "   - Dropbear                : 143, 109"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8080 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Badvpn                  : 7100, 7200, 7300"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo "   - Wireguard               : 7070"  | tee -a log-install.txt
echo "   - L2TP/IPSEC VPN          : 1701"  | tee -a log-install.txt
echo "   - PPTP VPN                : 1732"  | tee -a log-install.txt
echo "   - SSTP VPN                : 444"  | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443-1543"  | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443-2543"  | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443-3543"  | tee -a log-install.txt
echo "   - V2RAY Vmess TLS         : 8443"  | tee -a log-install.txt
echo "   - V2RAY Vmess None TLS    : 80"  | tee -a log-install.txt
echo "   - V2RAY Vless TLS         : 2083"  | tee -a log-install.txt
echo "   - V2RAY Vless None TLS    : 8880"  | tee -a log-install.txt
echo "   - Trojan                  : 2087"  | tee -a log-install.txt
echo "   - SSH WS TLS              : 2053"  | tee -a log-install.txt
echo "   - SSH WS TLS              : 2095"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05.00 GMT +7" | tee -a log-install.txt
echo "   - Autobackup Data" | tee -a log-install.txt
echo "   - Restore Data" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "------------------Script Created By Bowo-----------------" | tee -a log-install.txt
echo ""
echo " reboot 10 Sec"
sleep 10
rm -f setup.sh
reboot
