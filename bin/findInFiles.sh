#!/bin/bash
LIST=(Math\.BaseClasses\.OneNonLinearEquation)
i=0
while [ $i -le 1 ]; do
 OLD=${LIST[$i]}
 NEW=${LIST[$i+1]}
 i=$[ i + 2 ]

OLDFIL=`echo $OLD | sed -e 's|\.|/|g' -`
OLDMO=${OLDFIL}.mo
OLDMS=${OLDFIL}.mos
NEWFIL=`echo $NEW | sed -e 's|\.|/|g' -`
NEWMO=${NEWFIL}.mo
NEWMS=${NEWFIL}.mos
echo "Processing $OLD $NEW"
#echo $OLDFIL $NEWFIL
#echo $OLDMO $NEWMO
#echo $OLDMS $NEWMS

# replace string in files
fl=`find . \( -name '*.mos' -or -name '*.mo' \)`
for ff in $fl; do
    egrep $OLD $ff > /dev/null
    if [ $? == 0 ]; then
	echo "Found string in file $ff"
#	sed "s/${OLD}/AAABBAAA/g" -i $ff
#	sed "s/AAABBAAA/${NEW}/g" -i $ff
    fi
done

# move file name in svn
##if [ -f $OLDMO ]; then
##    svn mv $OLDMO $NEWMO
##fi
##if [ -f $OLDMS ]; then
##    svn mv $OLDMS $NEWMS
##fi

done