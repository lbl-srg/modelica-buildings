#!/usr/bin/env python3
import sys
sys.path.append('../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e
import os

def check():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    print(dat_fil)

def main():
    # args = sys.argv[1:]
    arg = 'AirToWater_Buffalo.idf'
    dat_fil = arg.replace(".idf", ".dat")
    output_list =[
    'Environment:Site Outdoor Air Drybulb Temperature [C](Hourly)',
    'COOLSYS1 DEMAND SUPPLY SIDE INLET PIPE INLET NODE:System Node Temperature [C](Hourly)',
    'COOLSYS1 DEMAND SUPPLY SIDE INLET PIPE INLET NODE:System Node Mass Flow Rate [kg/s](Hourly)',
    'HEATSYS1 SUPPLY INLET NODE:System Node Temperature [C](Hourly)',
    'HEATSYS1 SUPPLY INLET NODE:System Node Mass Flow Rate [kg/s](Hourly)',
    'COOLSYS1 DEMAND INLET NODE:System Node Temperature [C](Hourly)',
    'HEATSYS1 DEMAND INLET NODE:System Node Temperature [C](Hourly)'
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=3600,
    final_time=31536000)

if __name__ == '__main__':
    main()
