#!/usr/bin/env python3
import sys
sys.path.append('../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

def check():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    print(dat_fil)

def main():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    output_list =[
    'Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)',
      'Environment:Site Outdoor Air Wetbulb Temperature [C](TimeStep)',
      'Environment:Site Outdoor Air Relative Humidity [%](TimeStep)',
      'EVAPORATIVE COOLER:Evaporative Cooler Electricity Rate [W](TimeStep)',
      'EVAP COOLER INLET NODE:System Node Temperature [C](TimeStep)',
      'EVAP COOLER INLET NODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)',
      'SUPPLY OUTLET NODE:System Node Temperature [C](TimeStep)',
      'SUPPLY OUTLET NODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)',
      'SUPPLY OUTLET NODE:System Node Mass Flow Rate [kg/s](TimeStep)',
      'Environment:Site Outdoor Air Humidity Ratio [kgWater/kgDryAir](TimeStep)'
    ]
    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=600,
    final_time=1200000)

if __name__ == '__main__':
    main()
