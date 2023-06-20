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
    "Environment:Site Outdoor Air Drybulb Temperature [C](TimeStep)", #1
    "WEST ZONE:Zone Air System Sensible Heating Rate [W](TimeStep)", #2
    "WEST ZONE:Zone Air System Sensible Cooling Rate [W](TimeStep)", #3
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",#4
    "WEST ZONE:Zone Air Humidity Ratio [](TimeStep)",#5
    "WEST ZONE:Zone Air Relative Humidity [%](TimeStep)",#6
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",#7
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",#8
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Sensible Heating Rate [W](TimeStep)",#9
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Removed Water Mass Flow Rate [kg/s](TimeStep)",#10
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Electricity Rate [W](TimeStep)",#11
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Part Load Ratio [](TimeStep)",#12
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Runtime Fraction [](TimeStep)",#13
    "WEST ZONE DEHUMIDIFIER:Zone Dehumidifier Outlet Air Temperature [C](TimeStep)",#14
    "DEHUMIDIFIER OUTLET NODE:System Node Mass Flow Rate [kg/s](TimeStep)",#15
    "DEHUMIDIFIER OUTLET NODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#16
    "DEHUMIDIFIER OUTLET NODE:System Node Standard Density Volume Flow Rate [m3/s](TimeStep)",#17
    "ZONE1DEHUMIDIFIERINLET:System Node Temperature [C](TimeStep)",#18
    "ZONE1DEHUMIDIFIERINLET:System Node Mass Flow Rate [kg/s](TimeStep)",#19
    "ZONE1DEHUMIDIFIERINLET:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#20
    "ZONE1DEHUMIDIFIERINLET:System Node Standard Density Volume Flow Rate [m3/s](TimeStep)"#21
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
