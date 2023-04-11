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
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Total Cooling Rate [W](TimeStep)",#1
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Sensible Cooling Rate [W](TimeStep)",#2
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Latent Cooling Rate [W](TimeStep)",#3
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Electricity Rate [W](TimeStep)",#4
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Runtime Fraction [](TimeStep)",#5
    "ZONE1PTHPDXHEATCOIL:Heating Coil Heating Rate [W](TimeStep)",#6
    "ZONE1PTHPDXHEATCOIL:Heating Coil Electricity Rate [W](TimeStep)",#7
    "ZONE1PTHPDXHEATCOIL:Heating Coil Runtime Fraction [](TimeStep)",#8
    "ZONE1PTHPDXHEATCOIL:Heating Coil Defrost Electricity Rate [W](TimeStep)",#9
    "ZONE1PTHPSUPHEATER:Heating Coil Electricity Rate [W](TimeStep)",#10
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Total Heating Rate [W](TimeStep)",#11
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Total Cooling Rate [W](TimeStep)",#12
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Sensible Heating Rate [W](TimeStep)",#13
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Sensible Cooling Rate [W](TimeStep)",#14
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Latent Heating Rate [W](TimeStep)",#15
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Latent Cooling Rate [W](TimeStep)",#16
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Electricity Rate [W](TimeStep)",#17
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Fan Part Load Ratio [](TimeStep)",#18
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Compressor Part Load Ratio [](TimeStep)",#19
    "ZONE1PTHPOAMIXEROUTLETNODE:System Node Temperature [C](TimeStep)",#20
    "ZONE1PTHPOAMIXEROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#21
    "ZONE1PTHPOAMIXEROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#22
    "ZONE1PTHPAIROUTLETNODE:System Node Temperature [C](TimeStep)",#23
    "ZONE1PTHPAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",#24
    "ZONE1PTHPAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",#25
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",#26
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",#27
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",#28
    "ZONE1PTHPFAN:Fan Electricity Rate [W](TimeStep)",#29
    "ZONE1PTHPFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",#30
    "ZONE1PTHPFAN:Fan Heat Gain to Air [W](TimeStep)",#31
    "ZONE1PTHPFAN:Fan Rise in Air Temperature [deltaC](TimeStep)"#32
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=432000)

if __name__ == '__main__':
    main()
