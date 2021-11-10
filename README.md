Langkah 1 :

apt install wget && apt update && apt upgrade -y && update-grub && sleep 2 && reboot

Langkah 2 :

rm -rf setup.sh && sysctl -w net.ipv6.conf.all.disable_ipv6=1 && sysctl -w net.ipv6.conf.default.disable_ipv6=1 && apt install curl && wget https://raw.githubusercontent.com/Dimas1441/sc/main/setup.sh && apt update && apt install dos2unix && dos2unix setup.sh && chmod +x setup.sh && ./setup.sh

# For Your Information

For :
- Debian 9 & Debian 10 64 bit
- Ubuntu 18.04 & Ubuntu 20.04 64 bit
- VPS with KVM and VMWare virtualization
