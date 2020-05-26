#!/bin/bash


#------ sync-labsvault.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/sync-labsvault.sh -O /tmp/sync-labsvault.sh
if [ $? -eq 0 ]; then
	cp /tmp/sync-labsvault.sh /etc/cron.hourly/sync-labsvault.sh
	chmod 755 /etc/cron.hourly/90sync-labsvault.sh
fi
#------ update_images.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/update_images.sh -O /tmp/update_images.sh
if [ $? -eq 0 ]; then
	cp /tmp/update_images.sh /etc/cron.daily/update_images.sh
	chmod 755 /etc/cron.daily/91update_images.sh
fi