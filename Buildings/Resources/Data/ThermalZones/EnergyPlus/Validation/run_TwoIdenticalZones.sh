#!/bin/bash
set -e

idf_file=TwoIdenticalZones.idf

EnergyPlus --readvars --annual --output-directory EnergyPlus -w ../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw $idf_file
python3 csv_to_mos_TwoIdenticalZones.py
rm -rf EnergyPlus
