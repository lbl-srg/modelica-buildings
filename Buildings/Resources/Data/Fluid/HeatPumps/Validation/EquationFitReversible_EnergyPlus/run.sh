#!/bin/bash
set -e
EnergyPlus \
  --readvars \
  --output-directory EnergyPlus \
  -w ../../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw \
  GSHPSimple-GLHE-ReverseHeatPump.idf
python3 csv_to_mos.py GSHPSimple-GLHE-ReverseHeatPump.dat
rm -rf EnergyPlus
