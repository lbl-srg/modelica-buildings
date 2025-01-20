#!/bin/bash
set -e
idf_file=`AirToWater_Buffalo.idf`
python csv_to_mos.py "$idf_file"
#rm -rf EnergyPlus
