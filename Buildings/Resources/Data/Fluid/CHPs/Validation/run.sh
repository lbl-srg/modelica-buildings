#!/bin/bash
set -e
EnergyPlus --readvars -d EnergyPlus -w ../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw MicroCogeneration.idf
python energyplus_to_modelica.py
rm -rf EnergyPlus
