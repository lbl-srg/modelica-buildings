#!/usr/bin/env python3
import sys
sys.path.append('../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

if __name__ == '__main__':
  dat_fil = "RefBldgSmallOfficeNew2004_Chicago.dat"
  output_list =[
    "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)",
    "Environment:Site Outdoor Air Relative Humidity [%](TimeStep)",
    "ATTIC:Zone Mean Air Temperature [C](TimeStep)",
    "CORE_ZN:Zone Mean Air Temperature [C](TimeStep)",
    "PERIMETER_ZN_1:Zone Mean Air Temperature [C](TimeStep)",
    "PERIMETER_ZN_2:Zone Mean Air Temperature [C](TimeStep)",
    "PERIMETER_ZN_3:Zone Mean Air Temperature [C](TimeStep)",
    "PERIMETER_ZN_4:Zone Mean Air Temperature [C](TimeStep)"
  ]

  e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=600,
    final_time=7*24*3600)
