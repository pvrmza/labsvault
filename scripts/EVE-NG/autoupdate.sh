#!/bin/bash


#------ sync-labsvault.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/sync-labsvault.sh -O /tmp/sync-labsvault.sh
if [ $? -eq 0 ]; then
	cp /tmp/sync-labsvault.sh /etc/cron.hourly/90sync-labsvault
	chmod 755 /etc/cron.hourly/90sync-labsvault
fi
#------ update_images.sh
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/update_images.sh -O /tmp/update_images.sh
if [ $? -eq 0 ]; then
	cp /tmp/update_images.sh /etc/cron.daily/91update_images
	chmod 755 /etc/cron.daily/91update_images
fi