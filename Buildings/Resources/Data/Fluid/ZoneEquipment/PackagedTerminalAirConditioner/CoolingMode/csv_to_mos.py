#!/usr/bin/env python3
import sys
sys.path.append('../../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

def check():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    print(dat_fil)

def main():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    output_list =[
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Electricity Rate [W](TimeStep)",#1
    "ZONE1PTACHEATER:Heating Coil Heating Rate [W](TimeStep)",#2
    "ZONE1PTACHEATER:Heating Coil Electricity Rate [W](TimeStep)",#3
    "ZONE1PTACOAMIXEROUTLETNODE:System Node Temperature [C](TimeStep)",#4
    "ZONE1PTACAIROUTLETNODE:System Node Temperature [C](TimeStep)",#5
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",#6
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",#7
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",#8
    "ZONE1PTACFAN:Fan Electricity Rate [W](TimeStep)",#9
    "ZONE1PTACFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)"#10
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=10*86400)

if __name__ == '__main__':
    main()
