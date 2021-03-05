#!/bin/bash

LOG="/var/log/sync-labsvault.log"
DIRLOCALLABS=/opt/unetlab/labs/labsvault
DIRREMOTELABS=EVE-NG
URLLABS=https://github.com/pvrmza/labsvault/trunk/$DIRREMOTELABS/

#
echo "iniciando..." > $LOG
date >> $LOG

# svn -> tmp
cd /tmp
rm -rf $DIRREMOTELABS
svn checkout $URLLABS >> $LOG
if [ $? -eq 0 ]; then
        # tmp -> dir local
        rm -rf $DIRLOCALLABS && mkdir -p $DIRLOCALLABS
        rsync -avz --exclude='.svn*' --delete $DIRREMOTELABS/* $DIRLOCALLABS >> $LOG

        # fix 
        chown www-data.www-data $DIRLOCALLABS -R
        chmod 555 $DIRLOCALLABS -R
        echo "lab sync [OK]" >> $LOG
else
        echo "fallo SVN CHECKOUT" >> $LOG
fi
