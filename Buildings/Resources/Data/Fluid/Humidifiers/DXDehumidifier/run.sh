#!/bin/bash
set -e
idf_files="."/*.idf
for entry in $idf_files
do
echo "$entry"
energyplus \
  --readvars \
  --output-directory EnergyPlus \
  -w ../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw \
  "$entry"
python csv_to_mos.py "$entry"
rm -rf EnergyPlus
done
