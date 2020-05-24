#!/bin/bash

BASE="/opt/unetlab/addons"
LIST="images.list"

if ! test -f ${BASE}/${LIST} ; then
	echo "${BASE}/${LIST} not exist"
	exit 1
fi

while IFS= read -r line
do   
	DIR=`echo $line | awk -F\| '{ print $1 }'`
	FILE=`echo $line | awk -F\| '{ print $2 }'`
	SHA1=`echo $line | awk -F\| '{ print $3 }'`
	URL=`echo $line | awk -F\| '{ print $4 }'`

	FileLocal=${BASE}${DIR}${FILE}

	if test -d ${BASE}${DIR} ; then
		if test -f ${FileLocal} ; then
			sha1=`sha1sum ${FileLocal} | awk '{ print $1}' `
			if [ $SHA1 != $sha1 ]; then
				rm -rf ${FileLocal}
				mkdir -p ${BASE}${DIR} && megadl --path=${FileLocal} ${URL}
			else
				echo "${FileLocal} is update"
			fi
		else
			mkdir -p ${BASE}${DIR} && megadl --path=${FileLocal} ${URL}
		fi
	else
		mkdir -p ${BASE}${DIR} && megadl --path=${FileLocal} ${URL}
	fi
done < <( cat ${BASE}/${LIST} )

/opt/unetlab/wrappers/unl_wrapper -a fixpermissions