#!/bin/bash
set -e
EnergyPlus --readvars -d EnergyPlus -w ../../../../weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw RefBldgSmallOfficeNew2004_Chicago.idf
python csv_to_mos_RefBldgSmallOfficeNew2004_Chicago.py
rm -rf EnergyPlus
