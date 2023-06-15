#!/usr/bin/env python3
import sys
sys.path.append('../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

def check():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    print(dat_fil)

def main():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    output_list =[
    "ZONE1WINDAC:Zone Window Air Conditioner Total Cooling Rate [W](TimeStep)",
    "ZONE1WINDAC:Zone Window Air Conditioner Sensible Cooling Rate [W](TimeStep)",
    "ZONE1WINDAC:Zone Window Air Conditioner Electricity Rate [W](TimeStep)",
    "ZONE1WINDAC:Zone Window Air Conditioner Fan Part Load Ratio [](TimeStep)",
    "ZONE1WINDAC:Zone Window Air Conditioner Compressor Part Load Ratio [](TimeStep)",
    "ZONE1WINDAC:Zone Window Air Conditioner Fan Availability Status [](TimeStep)",
    "ZONE1WINDACAIRINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1WINDACAIROUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1WINDACAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1WINDACAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1WINDACAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1WINDACAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",
    "ZONE1WINDACFAN:Fan Electricity Rate [W](TimeStep)",
    "ZONE1WINDACFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1WINDACFAN:Fan Heat Gain to Air [W](TimeStep)",
    "ZONE1WINDACFAN:Fan Runtime Fraction [](TimeStep)",
    "ZONE1WINDACOAINNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1WINDACOAINNODE:System Node Temperature [C](TimeStep)",
    "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
