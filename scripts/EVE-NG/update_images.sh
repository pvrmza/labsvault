#!/bin/bash

LOG="/var/log/update_images.log"
BASE="/opt/unetlab/addons"
LIST="images.list"
IMAGESLIST="https://kutt.it/lv-images-list"
#
echo "iniciando..." > $LOG
date >> $LOG

# download new images.list
rm -rf ${BASE}/${LIST}
megaurl=`curl -s $IMAGESLIST | cut -b 23-`
megadl --path=${BASE} $megaurl >>$LOG

if ! test -f ${BASE}/${LIST} ; then
        # if download fail... exit...
        echo "${BASE}/${LIST} not exist" >> $LOG
        exit 1
fi


while IFS= read -r line
do
        DIR=`echo $line | awk -F\| '{ print $1 }'`
        FILE=`echo $line | awk -F\| '{ print $2 }'`
        SHA1=`echo $line | awk -F\| '{ print $3 }'`
        TINYURL=`echo $line | awk -F\| '{ print $4 }'`
        URL=`curl -s $TINYURL | cut -b 23-`

        FileLocal=${BASE}${DIR}${FILE}

        if test -d ${BASE}${DIR} ; then
                if test -f ${FileLocal} ; then
                        sha1=`sha1sum ${FileLocal} | awk '{ print $1}' `
                        if [ $SHA1 != $sha1 ]; then
                                rm -rf ${FileLocal}
                                echo "Downloading ${FILE} in ${BASE}${DIR}..." >> $LOG
                                mkdir -p ${BASE}${DIR} && megadl --path=${FileLocal} ${URL} >> $LOG
                        else
                                echo "${FileLocal} is update" >> $LOG
                        fi
                else
                        echo "Downloading ${FILE} in ${BASE}${DIR}..." >> $LOG
                        mkdir -p ${BASE}${DIR} && megadl --path=${FileLocal} ${URL} >> $LOG
                fi
        else
                echo "Downloading ${FILE} in ${BASE}${DIR}..." >> $LOG
                mkdir -p ${BASE}${DIR} && megadl --path=${FileLocal} ${URL} >> $LOG
        fi
done < <( cat ${BASE}/${LIST} ) >> $LOG

/opt/unetlab/wrappers/unl_wrapper -a fixpermissions >> $LOG
