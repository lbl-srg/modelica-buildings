#!/bin/bash
fl=`find . -name '*.mos'`
for ff in $fl; do
    grep "Fluids.Media" $ff > /dev/null
    if [ $? == 0 ]; then
	echo "File: $ff"
	grep "Fluids.Media" $ff 
#	sed 's/Buildings.Fluids.Media/Buildings.Media/g' -i $ff
#	sed 's/Fluids.Media/Buildings.Media/g' -i $ff
    fi
done