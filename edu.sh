#!/bin/bash
# Proxy For Edukasi Ssh & Ovpn Websocket
# ====================================

# Getting Proxy Template
wget -q -O /usr/local/bin/edu-ssh https://raw.githubusercontent.com/aryprabow/sc/main/proxy-template.py
chmod +x /usr/local/bin/edu-ssh

# Installing Service
cat > /etc/systemd/system/edussh-nontls.service << END
[Unit]
Description=Ssh Websocket By Brody
Documentation=https://t.me/brody_waemang
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-ssh 2095
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edussh-nontls
systemctl restart edussh-nontls

# Installing Service
cat > /etc/systemd/system/edussh-tls.service << END
[Unit]
Description=Ssh Websocket By Brody
Documentation=https://t.me/brody_waemang
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-ssh 100
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edussh-tls
systemctl restart edussh-tls

# Ovpn Websocket !!!
# =================================

# Getting Ovpn Ws Template
wget -q -O /usr/local/bin/edu-ovpn https://raw.githubusercontent.com/aryprabow/sc/main/edu-op.py
chmod +x /usr/local/bin/edu-ovpn


# Installing Service Ovpn Websocket
cat > /etc/systemd/system/edu-ovpn.service << END
[Unit]
Description=Ovpn Websocket By Brody
Documentation=https://t.me/brody_waemang
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/bin/python -O /usr/local/bin/edu-ovpn 2082
Restart=on-failure

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable edu-ovpn
systemctl restart edu-ovpn

clear
echo -e "==============================="
echo -e "Done Install Ssh & Ovpn Websocket"
echo -e "==============================="
echo -e "PORT SSH NONTLS : 2095"
echo -e "PORT SSH TLS         : 443"
echo -e "PORT OVPN WS B    : 2082"
echo -e "==============================="
echo -e "Script By Brody"
