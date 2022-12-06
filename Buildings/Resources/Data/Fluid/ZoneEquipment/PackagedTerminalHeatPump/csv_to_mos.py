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
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Total Cooling Rate [W](TimeStep)",
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Sensible Cooling Rate [W](TimeStep)",
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Latent Cooling Rate [W](TimeStep)",
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Electricity Rate [W](TimeStep)",
    "ZONE1PTHPDXCOOLCOIL:Cooling Coil Runtime Fraction [](TimeStep)",
    "ZONE1PTHPDXHEATCOIL:Heating Coil Heating Rate [W](TimeStep)",
    "ZONE1PTHPDXHEATCOIL:Heating Coil Electricity Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Total Heating Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Total Cooling Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Sensible Heating Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Sensible Cooling Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Latent Heating Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Latent Cooling Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Electricity Rate [W](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Fan Part Load Ratio [](TimeStep)",
    "ZONE1PTHP:Zone Packaged Terminal Heat Pump Compressor Part Load Ratio [](TimeStep)",
    "ZONE1PTHPAIRINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1PTHPAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1PTHPAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1PTHPAIROUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1PTHPAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1PTHPAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",
    "ZONE1PTHPFAN:Fan Electricity Rate [W](TimeStep)",
    "ZONE1PTHPFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1PTHPFAN:Fan Heat Gain to Air [W](TimeStep)",
    "ZONE1PTHPFAN:Fan Rise in Air Temperature [deltaC](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
