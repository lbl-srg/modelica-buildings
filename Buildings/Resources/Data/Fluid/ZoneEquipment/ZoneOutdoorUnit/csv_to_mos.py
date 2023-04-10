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
    "ACDXCOIL 1:Cooling Coil Total Cooling Rate [W](TimeStep)",
    "ACDXCOIL 1:Cooling Coil Sensible Cooling Rate [W](TimeStep)",
    "ACDXCOIL 1:Cooling Coil Latent Cooling Rate [W](TimeStep)",
    "ACDXCOIL 1:Cooling Coil Electricity Rate [W](TimeStep)",
    "ACDXCOIL 1:Cooling Coil Runtime Fraction [](TimeStep)",
    "ZONE1OAUHEATINGCOIL:Heating Coil Heating Rate [W](TimeStep)",
    "ZONE1OAUHEATINGCOIL:Heating Coil Electricity Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Total Cooling Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Sensible Cooling Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Latent Cooling Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Total Heating Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Sensible Heating Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Latent Heating Rate [W](TimeStep)",
    "ZONE1OUTAIR:Zone Outdoor Air Unit Fan Electricity Rate [W](TimeStep)",
    "ZONE1OAUZONEOUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1OAUZONEOUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1OAUZONEOUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1OAUZONEINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1OAUZONEINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1OAUZONEINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "SPACE1-1:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "SPACE1-1:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "SPACE1-1:Zone Air Temperature [C](TimeStep)",
    "ZONE1OAUFAN:Fan Electricity Rate [W](TimeStep)",
    "ZONE1OAUFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1OAUFAN:Fan Heat Gain to Air [W](TimeStep)",
    "ZONE1OAUFAN:Fan Rise in Air Temperature [deltaC](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
