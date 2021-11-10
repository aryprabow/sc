#!/bin/bash

read -p "Masukan Domain Baru : " domainbaru

#Validate
if [[ $domainbaru == "" ]]; then
echo "Silahkan Masukan Domain Baru"
exit 1
fi

#Input To Domain
cat > /etc/v2ray/domain << END
$domainbaru
END

clear 
echo "SUKSES"