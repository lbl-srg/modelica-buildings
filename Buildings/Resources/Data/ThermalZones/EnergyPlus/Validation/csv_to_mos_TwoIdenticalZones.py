import pandas as pd

#!/usr/bin/env python3

import energyplus_csv_to_mos as e

if __name__ == '__main__':
  dat_fil = "TwoIdenticalZones.dat"
  output_list =[
    "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)",
    "Environment:Site Outdoor Air Wetbulb Temperature [C](TimeStep)",
    "THERMAL ZONE 1:Zone Air Temperature [C](TimeStep)",
    "THERMAL ZONE 1:Zone Air Relative Humidity [%](TimeStep)"
  ]

  e.energyplus_csv_to_mos(output_list = output_list, dat_file_name=dat_fil)

