#!/usr/bin/env python3
import sys
sys.path.append('../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

if __name__ == '__main__':
  dat_fil = "IndirectAbsorptionChiller.dat"
  output_list =[
   "BIG CHILLER:Chiller Electricity Rate [W](TimeStep)",
   "BIG CHILLER:Chiller Evaporator Cooling Rate [W](TimeStep)",
   "BIG CHILLER:Chiller Evaporator Inlet Temperature [C](TimeStep)",
   "BIG CHILLER:Chiller Evaporator Outlet Temperature [C](TimeStep)",
   "BIG CHILLER:Chiller Evaporator Mass Flow Rate [kg/s](TimeStep)",
   "BIG CHILLER:Chiller Condenser Heat Transfer Rate [W](TimeStep)",
   "BIG CHILLER:Chiller Condenser Inlet Temperature [C](TimeStep)",
   "BIG CHILLER:Chiller Condenser Outlet Temperature [C](TimeStep)",
   "BIG CHILLER:Chiller Condenser Mass Flow Rate [kg/s](TimeStep)",
   "BIG CHILLER:Chiller Source Steam Rate [W](TimeStep)",
   "BIG CHILLER:Chiller Steam Heat Loss Rate [W](TimeStep)"
  ]

  e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=172800)
