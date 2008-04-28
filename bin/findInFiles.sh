#!/bin/bash
fl=`find . -name '*.mo'`
for ff in $fl; do
    grep "1000" $ff
    if [ $? == 0 ]; then
	echo $ff
    fi
done