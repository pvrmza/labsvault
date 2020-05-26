#!/bin/bash

while fuser /var/lib/dpkg/lock-frontend; do
	echo "Waiting...another process is using dpkg"
    sleep 5
done

apt-get update && apt-get install -y qemu-guest-agent open-vm-tools subversion rsync build-essential \
  libglib2.0-dev libssl-dev libcurl4-openssl-dev libgirepository1.0-dev pkg-config \
  genisoimage cloud-utils
if [ $? -ne 0 ]; then
	exit 1
fi

# para que solo muestre las plantillas cargadas 
cp /opt/unetlab/html/includes/config.php.distribution /opt/unetlab/html/includes/config.php

#------ set default values to template
# spanish keyboard
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

#------ megadl
cd /usr/local/src
wget -q https://megatools.megous.com/builds/megatools-1.10.3.tar.gz

tar -zxvf megatools-1.10.3.tar.gz
cd megatools-1.10.3
./configure --disable-docs && make && make install

#------ sync-labsvault.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/sync-labsvault.sh -O /tmp/sync-labsvault.sh
if [ $? -eq 0 ]; then
	cp /tmp/sync-labsvault.sh /etc/cron.hourly/90sync-labsvault.sh
	chmod 755 /etc/cron.hourly/90sync-labsvault.sh
fi
#------ update_images.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/update_images.sh -O /tmp/update_images.sh
if [ $? -eq 0 ]; then
	cp /tmp/update_images.sh /etc/cron.daily/91update_images.sh
	chmod 755 /etc/cron.daily/91update_images.sh
fi

#------ autoupdate.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/autoupdate.sh -O /tmp/autoupdate.sh
if [ $? -eq 0 ]; then
	cp /tmp/autoupdate.sh /etc/cron.daily/90autoupdate.sh
	chmod 755 /etc/cron.daily/90autoupdate.sh
fi

# ----- 
cat << EOF > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
hostnamectl set-hostname "eve-ng"
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
find /opt/unetlab/labs/ -name '*.lock' -exec rm {} \;

/etc/cron.daily/91update_images.sh 
/etc/cron.hourly/90sync-labsvault.sh 

exit 0
EOF

chmod 755 /etc/rc.local

/etc/cron.daily/91update_images.sh
/etc/cron.hourly/90sync-labsvault.sh

reboot

