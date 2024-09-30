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
      'WATER HEATER USE INLET NODE:System Node Temperature [C](TimeStep)',
      'WATER HEATER USE INLET NODE:System Node Mass Flow Rate [kg/s](TimeStep)',
      'WATER HEATER USE OUTLET NODE:System Node Temperature [C](TimeStep)',
      'WATER HEATER USE OUTLET NODE:System Node Mass Flow Rate [kg/s](TimeStep)',
      'HPPLANTAIRINLETNODE:System Node Temperature [C](TimeStep)',
      'HPPLANTAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)',
      'HPPLANTAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)',
      'HPPLANTAIROUTLETNODE:System Node Temperature [C](TimeStep)',
      'HPPLANTFANAIROUTLETNODE:System Node Temperature [C](TimeStep)',
      'WATER HEATER TANK:Water Heater Temperature Node 1 [C](TimeStep)',
      'WATER HEATER TANK:Water Heater Temperature Node 2 [C](TimeStep)',
      'WATER HEATER TANK:Water Heater Temperature Node 3 [C](TimeStep)',
      'WATER HEATER TANK:Water Heater Temperature Node 4 [C](TimeStep)',
      'WATER HEATER TANK:Water Heater Temperature Node 5 [C](TimeStep)',   
      'HPWHPLANTDXCOIL:Cooling Coil Water Heating Electricity Rate [W](TimeStep)',
      'HPWHPLANTFAN:Fan Electricity Rate [W](TimeStep)',
      'HPWHPLANTDXCOIL:Cooling Coil Total Water Heating Rate [W](TimeStep)',
      'WATER HEATER TANK:Water Heater Heat Loss Rate [W](TimeStep)',
      'HPWH-HTG-CAP-FT:Performance Curve Input Variable 1 Value [](TimeStep)',
      'HPWH-HTG-CAP-FT:Performance Curve Input Variable 2 Value [](TimeStep)',
      'HPWH-HTG-CAP-FT:Performance Curve Output Value [](TimeStep)',
      'HPWH-HTG-COP-FT:Performance Curve Output Value [](TimeStep)'
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    start_time=18316800,
    final_time=19526400)

if __name__ == '__main__':
    main()
