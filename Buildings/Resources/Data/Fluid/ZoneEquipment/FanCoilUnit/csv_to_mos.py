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
    "ZONE1FANCOIL:Fan Coil Heating Rate [W](TimeStep)",
    "ZONE1FANCOIL:Fan Coil Total Cooling Rate [W](TimeStep)",
    "ZONE1FANCOIL:Fan Coil Fan Electricity Rate [W](TimeStep)",
    "ZONE1FANCOILAIROUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1FANCOILAIRINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1FANCOILAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1FANCOILCHWINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1FANCOILCHWINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1FANCOILHWINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1FANCOILHWINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1FANCOILAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",
    "ZONE1FANCOIL:Fan Coil Sensible Cooling Rate [W](TimeStep)",
    "ZONE1FANCOILAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1FANCOILOAMIXEROUTLETNODE:System Node Pressure [Pa](TimeStep)",
    "ZONE1FANCOILFANOUTLETNODE:System Node Pressure [Pa](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
