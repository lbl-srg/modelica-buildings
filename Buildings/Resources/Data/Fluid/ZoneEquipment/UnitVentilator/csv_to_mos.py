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
    "ZONE1UNITVENTCOOLINGCOIL:Cooling Coil Total Cooling Rate [W](TimeStep)",
    "ZONE1UNITVENTCOOLINGCOIL:Cooling Coil Sensible Cooling Rate [W](TimeStep)",
    "ZONE1UNITVENTHEATINGCOIL:Heating Coil Heating Rate [W](TimeStep)",
    "ZONE1UNITVENT:Zone Unit Ventilator Total Cooling Rate [W](TimeStep)",
    "ZONE1UNITVENT:Zone Unit Ventilator Sensible Cooling Rate [W](TimeStep)",
    "ZONE1UNITVENT:Zone Unit Ventilator Heating Rate [W](TimeStep)",
    "ZONE1UNITVENT:Zone Unit Ventilator Fan Electricity Rate [W](TimeStep)",
    "ZONE1UNITVENTAIROUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1UNITVENTAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1UNITVENTAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1UNITVENTAIRINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1UNITVENTAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1UNITVENTAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "SPACE1-1:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "SPACE1-1:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "SPACE1-1:Zone Air Temperature [C](TimeStep)",
    "ZONE1UNITVENTFAN:Fan Electricity Rate [W](TimeStep)",
    "ZONE1UNITVENTFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1UNITVENTFAN:Fan Heat Gain to Air [W](TimeStep)",
    "ZONE1UNITVENTFAN:Fan Rise in Air Temperature [deltaC](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
