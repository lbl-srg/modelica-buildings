#!/bin/bash
set -e
EnergyPlus --readvars --output-directory EnergyPlus -w ../../../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw CoolingTower_VariableSpeed_Merkel.idf
python3 csv_to_mos.py
rm -rf EnergyPlus
