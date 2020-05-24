#!/bin/bash

# auto update !!! 
wget https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/sync-labsvault.sh -O /tmp/sync-labsvault.sh
if [ $? -eq 0 ]; then
	cp /tmp/sync-labsvault.sh /etc/cron.hourly/sync-labsvault.sh
fi

#
DIRLOCALLABS=/opt/unetlab/labs/labs
DIRREMOTELABS=EVE-NG
URLLABS=https://github.com/pvrmza/labsvault/trunk/$DIRREMOTELABS/

# svn -> tmp
cd /tmp
rm -rf $DIRREMOTELABS
svn checkout $URLLABS

# tmp -> dir local
mkdir -p $DIRLOCALLABS
rsync -avz --exclude='.svn*' --delete $DIRREMOTELABS/* $DIRLOCALLABS

# fix 
chown www-data.www-data $DIRLOCALLABS -R 
find $DIRLOCALLABS -type f -exec chmod 555 {} \; 
