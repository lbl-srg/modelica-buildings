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
    "ZONE1WINDAC:Zone Window Air Conditioner Total Cooling Rate [W](TimeStep)",#1
    "ZONE1WINDAC:Zone Window Air Conditioner Sensible Cooling Rate [W](TimeStep)",#2
    "ZONE1WINDAC:Zone Window Air Conditioner Electricity Rate [W](TimeStep)",#3
    "ZONE1WINDAC:Zone Window Air Conditioner Fan Part Load Ratio [](TimeStep)",#4
    "ZONE1WINDAC:Zone Window Air Conditioner Compressor Part Load Ratio [](TimeStep)",#5
    "ZONE1WINDAC:Zone Window Air Conditioner Fan Availability Status [](TimeStep)",#6
    "ZONE1WINDACAIRINLETNODE:System Node Temperature [C](TimeStep)",#7
    "ZONE1WINDACAIROUTLETNODE:System Node Temperature [C](TimeStep)",#8
    "ZONE1WINDACAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#9
    "ZONE1WINDACAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#10
    "ZONE1WINDACAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#11
    "ZONE1WINDACAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#12
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",#13
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",#14
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",#15
    "ZONE1WINDACFAN:Fan Electricity Rate [W](TimeStep)",#16
    "ZONE1WINDACFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",#17
    "ZONE1WINDACFAN:Fan Heat Gain to Air [W](TimeStep)",#18
    "ZONE1WINDACFAN:Fan Runtime Fraction [](TimeStep)",#19
    "ZONE1WINDACOAINNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#20
    "ZONE1WINDACOAINNODE:System Node Temperature [C](TimeStep)",#21
    "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)"#22
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
