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
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",#4
    "WEST ZONE:Zone Air Relative Humidity [%](TimeStep)",#6
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Sensible Heating Rate [W](TimeStep)",#9
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Removed Water Mass Flow Rate [kg/s](TimeStep)",#10
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Electricity Rate [W](TimeStep)",#11
    "ZONE1DEHUMIDIFIERINLET:System Node Mass Flow Rate [kg/s](TimeStep)",#19
    "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    start_time=12960000,
    final_time=15120000)

if __name__ == '__main__':
    main()
