#!/bin/bash
set -e
idf=/usr/local/EnergyPlus-9-3-0/ExampleFiles/RefBldgSmallOfficeNew2004_Chicago.idf
idf_file=`basename $idf`
### If idf is copied, make sure to delete all HVAC and all infiltration objects
### if [ -f $idf ]; then
###   cp $idf .
###   sed -e 's/,HOURLY;$/,timestep;/g' $idf_file > $idf_file.bak
###   mv $idf_file.bak $idf_file
###   sed -e 's/,hourly;$/,timestep;/g' $idf_file > $idf_file.bak
###   mv $idf_file.bak $idf_file
### else
###   echo "*** Error: Did not find $idf"
###   exit 1
### fi

EnergyPlus --readvars --annual --output-directory EnergyPlus -w ../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw $idf_file
python3 csv_to_mos_RefBldgSmallOfficeNew2004_Chicago.py
rm -rf EnergyPlus
