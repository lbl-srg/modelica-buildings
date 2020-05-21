#!/usr/bin/env python3
import sys
sys.path.append('../../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

if __name__ == '__main__':
  dat_fil = "CoolingTower_VariableSpeed_Merkel.dat"
  output_list =[
   "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)",
   "Environment:Site Outdoor Air Wetbulb Temperature [C](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Inlet Temperature [C](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Outlet Temperature [C](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Mass Flow Rate [kg/s](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Heat Transfer Rate [W](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Fan Electric Power [W](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Fan Electric Energy [J](TimeStep)",
   "CENTRAL TOWER:Cooling Tower Fan Speed Ratio [](TimeStep)"
  ]

  e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=172800)
