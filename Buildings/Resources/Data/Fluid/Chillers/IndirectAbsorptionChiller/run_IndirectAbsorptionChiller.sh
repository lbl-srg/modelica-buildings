#!/bin/bash
set -e
EnergyPlus --readvars -d EnergyPlus -w ../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw IndirectAbsorptionChiller.idf
python csv_to_mos_IndirectAbsorptionChiller.py
rm -rf EnergyPlus
