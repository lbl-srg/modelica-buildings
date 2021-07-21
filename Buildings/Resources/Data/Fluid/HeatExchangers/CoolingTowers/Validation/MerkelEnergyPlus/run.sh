#!/bin/bash
set -e
<<<<<<< HEAD
EnergyPlus --readvars -d EnergyPlus -w ../../../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw CoolingTower_VariableSpeed_Merkel.idf
python energyplus_to_modelica.py
=======
idf_file=`ls *.idf`
energyplus \
  --readvars \
  --output-directory EnergyPlus \
  -w ../../../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw \
  ${idf_file}
python3 csv_to_mos.py
>>>>>>> master
rm -rf EnergyPlus
