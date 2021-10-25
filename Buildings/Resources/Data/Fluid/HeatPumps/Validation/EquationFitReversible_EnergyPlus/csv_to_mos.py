#!/usr/bin/env python3
import sys
sys.path.append('../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

if __name__ == '__main__':
  dat_fil = "GSHPSimple-GLHE-ReverseHeatPump.dat"
  output_list =[
    "GSHPHEATING:Heat Pump Electricity Rate [W](TimeStep)",
    "GSHPHEATING:Heat Pump Load Side Heat Transfer Rate [W](TimeStep)",
    "GSHPHEATING:Heat Pump Source Side Heat Transfer Rate [W](TimeStep)",
    "GSHPHEATING:Heat Pump Load Side Outlet Temperature [C](TimeStep)",
    "GSHPHEATING:Heat Pump Load Side Inlet Temperature [C](TimeStep)",
    "GSHPCLG:Heat Pump Source Side Outlet Temperature [C](TimeStep)",
    "GSHPCLG:Heat Pump Source Side Inlet Temperature [C](TimeStep)"
  ]

  e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=172800)
