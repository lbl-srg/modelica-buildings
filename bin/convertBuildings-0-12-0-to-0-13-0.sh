#!/bin/bash
#####################################################################
# This script replaces the strings defined in the array ORI with
# the string defined in NEW.
# The replacement will be done in all *.mo and *.mos files in 
# the current directory and in its subdirectories.
#
# Use this file with caution. 
# You may want to backup the current directory before running this
# script.
#
# Michael Wetter, LBNL                                     2009-09-29
#####################################################################
ORI=(\
##DynamicTwoPortTransformer \
##DynamicFourPortTransformer \
##TwoPortHeatMassTransfer \
##FourPortHeatMassTransfer \
RoomsBeta \
WindowsBeta \
)
NEW=(\
##TwoPortHeatMassExchanger \
##FourPortHeatMassExchanger \
##StaticTwoPortHeatMassExchanger \
##StaticFourPortHeatMassExchanger \
Rooms \
Windows \
)

# Number of strings to replace
iMax=${#NEW[@]}
echo $iMax
iOri=${#ORI[@]}
if [ $iMax != $iOri ]; then
    echo "Error: Cannot replace $iMax strings by $iOri strings"
    echo "       Did not change anything. Exit with error."
    exit 1
fi


# Find all *.mo and *.mos files, then replace the strings
for ff in `find . \( -name '*.mo' -or -name '*.mos' -or -name '*.txt' -not -name 'ConvertBuildings_from*' \)`; do
    iVar=0
    while [ $iVar -lt $iMax ]; do
        # Count how many times the original string is in the file
	co=`grep -c "${ORI[$iVar]}" $ff`;
	if [ $co -ge 1 ]; then
            # Found a string. Replace it.
	    echo $co $ff
	    sed -e "s/${ORI[$iVar]}/${NEW[$iVar]}/g" $ff > tmp.txt
	    mv tmp.txt $ff
	fi;
	iVar=$[ iVar + 1 ]
    done; 
done
