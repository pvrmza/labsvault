#!/bin/bash

# para que solo muestre las plantillas cargadas 
cp /opt/unetlab/html/includes/config.php.distribution /opt/unetlab/html/includes/config.php

# teclado en español
for file in `find /opt/unetlab/html/templates/ -type f -iname \???*.yml`
do
  sed -i 's/=kvm -vga /=kvm -k es -vga /g' $file
done

#IOL con 256MB andan...
for file in `find /opt/unetlab/html/templates/ -type f -iname iol.yml`
do
  sed -i 's/ram: 1024/ram: 256/g' $file
done

# igual que los linux.. 512MB sobra ! 
for file in `find /opt/unetlab/html/templates/ -type f -iname linux.yml`
do
  sed -i 's/ram: 2048/ram: 512/g' $file
done

#------ install megadl
apt-get update && apt-get -y install build-essential libglib2.0-dev libssl-dev libcurl4-openssl-dev libgirepository1.0-dev -y 

cd /usr/local/src
wget https://megatools.megous.com/builds/megatools-1.10.3.tar.gz
tar -zxvf megatools-1.10.3.tar.gz
cd megatools-1.10.3
make clean
./configure --disable-docs
make
make install

#------ sync-labsvault.sh
wget https://raw.githubusercontent.com/pvrmza/labsvault/master/EVE-NG/sync-labsvault.sh -O /etc/cron.hourly/sync-labsvault.sh
chmod 755 /etc/cron.hourly/sync-labsvault.sh

cat << EOF > /etc/rc.local
hostnamectl set-hostname "eve-ng"
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
find /opt/unetlab/labs/ -name '*.lock' -exec rm {} \;
/etc/cron.hourly/sync-labsvault.sh
exit 0
EOF

chmod 755 /etc/rc.local

