#!/usr/bin/env python3
import sys
sys.path.append('../../../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

def check():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    print(dat_fil)

def main():
    args = sys.argv[1:]
    dat_fil = "DXCoilSystemAuto.idf"
    #dat_fil = args[0].replace(".idf", ".dat")
    output_list =[
    'Environment:Site Outdoor Air Drybulb Temperature [C](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Heating Rate [W](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Electricity Rate [W](Hourly)',
      'HEATPUMP DX COIL 1:Coil System Part Load Ratio [](Hourly)',
      'HEATING COIL AIR INLET NODE:System Node Temperature [C](Hourly)',
      'HEATING COIL AIR INLET NODE:System Node Humidity Ratio [kgWater/kgDryAir](Hourly)',
      'SUPPHEATING COIL AIR INLET NODE:System Node Temperature [C](Hourly)',
      'SUPPHEATING COIL AIR INLET NODE:System Node Humidity Ratio [kgWater/kgDryAir](Hourly)',
      'Environment:Site Outdoor Air Humidity Ratio [kgWater/kgDryAir](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Heating Energy [J](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Electricity Energy [J](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Defrost Electricity Energy [J](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Crankcase Heater Electricity Energy [J](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Runtime Fraction [](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Defrost Electricity Rate [W](Hourly)',
      'HEAT PUMP DX HEATING COIL 1:Heating Coil Crankcase Heater Electricity Rate [W](Hourly)',
      'HEATING COIL AIR INLET NODE:System Node Mass Flow Rate [kg/s](Hourly)'
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=3600,
    final_time=172800)

if __name__ == '__main__':
    main()
