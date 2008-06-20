#!/bin/bash
OLD=FixedResistanceDpM
NEW=ResistanceDpMDh
fl=`find . \( -name '*.mos' -or -name '*.mo' \)`
for ff in $fl; do
    grep "$OLD" $ff > /dev/null
    if [ $? == 0 ]; then
	sed "s/${OLD}/AAABBAAA/g" -i $ff
	sed "s/AAABBAAA/${NEW}/g" -i $ff
    fi
done
