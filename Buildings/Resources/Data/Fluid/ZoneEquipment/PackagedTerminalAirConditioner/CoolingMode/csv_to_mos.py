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
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Total Cooling Rate [W](TimeStep)",#1
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Sensible Cooling Rate [W](TimeStep)",#2
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Latent Cooling Rate [W](TimeStep)",#3
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Electricity Rate [W](TimeStep)",#4
    "ZONE1PTACDXCOOLCOIL:Cooling Coil Runtime Fraction [](TimeStep)",#5
    "ZONE1PTACHEATER:Heating Coil Heating Rate [W](TimeStep)",#6
    "ZONE1PTACHEATER:Heating Coil Electricity Rate [W](TimeStep)",#7
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Total Heating Rate [W](TimeStep)",#8
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Total Cooling Rate [W](TimeStep)",#9
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Sensible Heating Rate [W](TimeStep)",#10
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Sensible Cooling Rate [W](TimeStep)",#11
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Latent Heating Rate [W](TimeStep)",#12
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Latent Cooling Rate [W](TimeStep)",#13
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Electricity Rate [W](TimeStep)",#14
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Fan Part Load Ratio [](TimeStep)",#15
    "ZONE1PTAC:Zone Packaged Terminal Air Conditioner Compressor Part Load Ratio [](TimeStep)",#16
    "ZONE1PTACOAMIXEROUTLETNODE:System Node Temperature [C](TimeStep)",#17
    "ZONE1PTACOAMIXEROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#18
    "ZONE1PTACOAMIXEROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#19
    "ZONE1PTACAIROUTLETNODE:System Node Temperature [C](TimeStep)",#20
    "ZONE1PTACAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#21
    "ZONE1PTACAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#22
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",#23
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",#24
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",#25
    "ZONE1PTACFAN:Fan Electricity Rate [W](TimeStep)",#26
    "ZONE1PTACFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",#27
    "ZONE1PTACFAN:Fan Heat Gain to Air [W](TimeStep)",#28
    "ZONE1PTACFAN:Fan Rise in Air Temperature [deltaC](TimeStep)"#29
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=105*86400)

if __name__ == '__main__':
    main()
