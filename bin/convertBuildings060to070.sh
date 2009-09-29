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
ORI=( Modelica_Fluid Buildings\.Fluids \
Fluids\.Actuators \
Fluids\.BaseClasses \
Fluids\.Boilers \
Fluids\.Chillers \
Fluids\.Delays \
Fluids\.FixedResistances \
Fluids\.HeatExchangers \
Fluids\.Images \
Fluids\.Interfaces \
Fluids\.MassExchangers \
Fluids\.MixingVolumes \
Fluids\.Movers \
Fluids\.Sensors \
Fluids\.Sources \
Fluids\.Storage \
Fluids\.Utilities \
Modelica\.Fluid\.Sensors \
Modelica\.Fluid\.Sources \
Buildings\.Fluid\.Sensors\.BaseClasses \
Buildings\.Fluid\.Sources\.BaseClasses \
)
NEW=( Modelica\.Fluid Buildings\.Fluid \
Fluid\.Actuators \
Fluid\.BaseClasses \
Fluid\.Boilers \
Fluid\.Chillers \
Fluid\.Delays \
Fluid\.FixedResistances \
Fluid\.HeatExchangers \
Fluid\.Images \
Fluid\.Interfaces \
Fluid\.MassExchangers \
Fluid\.MixingVolumes \
Fluid\.Movers \
Fluid\.Sensors \
Fluid\.Sources \
Fluid\.Storage \
Fluid\.Utilities \
Buildings\.Fluid\.Sensors \
Buildings\.Fluid\.Sources \
Modelica\.Fluid\.Sensors\.BaseClasses \
Modelica\.Fluid\.Sources\.BaseClasses \
)

# Number of strings to replace
iMax=${#NEW[@]}
echo $iMax

# Find all *.mo and *.mos files, then replace the strings
for ff in `find . \( -name '*.mo' -or -name '*.mos' \)`; do
    iVar=0
    while [ $iVar -lt $iMax ]; do
        # Count how many times the original string is in the file
	co=`grep -c ${ORI[$iVar]} $ff`;
	if [ $co -ge 1 ]; then
            # Found a string. Replace it.
	    echo $co $ff
	    sed -e "s/${ORI[$iVar]}/${NEW[$iVar]}/g" $ff > tmp.txt
	    mv tmp.txt $ff
	fi;
	iVar=$[ iVar + 1 ]
    done; 
done
