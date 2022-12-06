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
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Total Cooling Rate [W](TimeStep)",
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Sensible Cooling Rate [W](TimeStep)",
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Latent Cooling Rate [W](TimeStep)",
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Electricity Rate [W](TimeStep)",
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Runtime Fraction [](TimeStep)",
    "ZONE1PTACHEATER:Heating Coil Heating Rate [W](TimeStep)",
    "ZONE1PTACHEATER:Heating Coil Electricity Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Total Heating Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Total Cooling Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Sensible Heating Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Sensible Cooling Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Latent Heating Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Latent Cooling Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Electricity Rate [W](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Fan Part Load Ratio [](TimeStep)",
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Compressor Part Load Ratio [](TimeStep)",
    "ZONE1PTACAIRINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1PTACAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1PTACAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1PTACAIROUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1PTACAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1PTACAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",
    "ZONE1PTACFAN:Fan Electricity Rate [W](TimeStep)",
    "ZONE1PTACFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1PTACFAN:Fan Heat Gain to Air [W](TimeStep)",
    "ZONE1PTACFAN:Fan Rise in Air Temperature [deltaC](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
