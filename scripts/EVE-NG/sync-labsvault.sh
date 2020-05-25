#!/bin/bash

logger "iniciando..."
#
DIRLOCALLABS=/opt/unetlab/labs/labsvault
DIRREMOTELABS=EVE-NG
URLLABS=https://github.com/pvrmza/labsvault/trunk/$DIRREMOTELABS/

# svn -> tmp
cd /tmp
rm -rf $DIRREMOTELABS
svn checkout $URLLABS 
if [ $? -eq 0 ]; then
	# tmp -> dir local
	mkdir -p $DIRLOCALLABS
	rsync -avz --exclude='.svn*' --delete $DIRREMOTELABS/* $DIRLOCALLABS

	# fix 
	chown www-data.www-data $DIRLOCALLABS -R 
	find $DIRLOCALLABS -type f -exec chmod 555 {} \; 
	logger "lab sync [OK]"
else
	logger "fallo SVN CHECKOUT"
fi

# auto update !!! 
wget -q https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/sync-labsvault.sh -O /tmp/sync-labsvault.sh
if [ $? -eq 0 ]; then
	cp /tmp/sync-labsvault.sh /etc/cron.hourly/sync-labsvault.sh
	chmod 755 /etc/cron.hourly/sync-labsvault.sh
	logger "auto update [OK]"
fi

