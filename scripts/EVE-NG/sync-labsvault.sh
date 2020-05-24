#!/bin/bash

# update !!! 
wget https://raw.githubusercontent.com/pvrmza/labsvault/master/scripts/EVE-NG/sync-labsvault.sh -O /etc/cron.hourly/sync-labsvault.sh
#
DIRLOCALLABS=/opt/unetlab/labs/labs
DIRREMOTELABS=EVE-NG

URLLABS=https://github.com/pvrmza/labsvault/trunk/$DIRREMOTELABS/

cd /tmp
rm -rf $DIRREMOTELABS
svn checkout $URLLABS

mkdir -p $DIRLOCALLABS

rsync -avz --exclude='.svn*' --delete $DIRREMOTELABS/* $DIRLOCALLABS
chown www-data.www-data $DIRLOCALLABS -R 

find $DIRLOCALLABS -type f -exec chmod 555 {} \; 
