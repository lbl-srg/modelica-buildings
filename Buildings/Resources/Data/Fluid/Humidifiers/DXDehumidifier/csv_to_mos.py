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
    "WEST ZONE:Zone Air Temperature [C](Hourly)",#1
    "WEST ZONE:Zone Air Relative Humidity [%](Hourly)",#2
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Sensible Heating Rate [W](Hourly)",#3
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Removed Water Mass Flow Rate [kg/s](Hourly)",#4
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Electricity Rate [W](Hourly)",#5
    "ZONE1DEHUMIDIFIERINLET:System Node Mass Flow Rate [kg/s](Hourly)",#6
    "Environment:Site Outdoor Air Drybulb Temperature [C](Hourly)",#7
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Part Load Ratio [](Hourly)",#8
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Runtime Fraction [](Hourly)",#9
    "ZONE1DEHUMIDIFIERINLET:System Node Humidity Ratio [kgWater/kgDryAir](Hourly)",#10
    "ZONE1DEHUMIDIFIERINLET:System Node Temperature [C](Hourly)", #11
    "DEHUMIDIFIER OUTLET NODE:System Node Temperature [C](Hourly)", #12
    "DEHUMIDIFIER OUTLET NODE:System Node Humidity Ratio [kgWater/kgDryAir](Hourly)", #13
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Outlet Air Temperature [C](Hourly)" #14
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=3600,
    start_time=12960000,
    final_time=15120000)

if __name__ == '__main__':
    main()
