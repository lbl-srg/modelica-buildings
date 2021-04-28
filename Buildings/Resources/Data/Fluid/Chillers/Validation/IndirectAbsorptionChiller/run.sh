#!/bin/bash
set -e
idf_file=`ls *.idf`
energyplus \
  --readvars \
  --output-directory EnergyPlus \
  -w ../../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw \
  ${idf_file}
python3 csv_to_mos.py
rm -rf EnergyPlus
