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
    "ZONE1UNITHEAT:Zone Unit Heater Heating Rate [W](TimeStep)",
    "ZONE1UNITHEAT:Zone Unit Heater Fan Electricity Rate [W](TimeStep)",
    "ZONE1UNITHEAT:Zone Unit Heater Fan Availability Status [](TimeStep)",
    "ZONE1UNITHEATHEATINGCOIL:Heating Coil Heating Rate [W](TimeStep)",
    "ZONE1UNITHEATAIRINLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1UNITHEATAIROUTLETNODE:System Node Temperature [C](TimeStep)",
    "ZONE1UNITHEATAIRINLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1UNITHEATAIROUTLETNODE:System Node Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1UNITHEATAIRINLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "ZONE1UNITHEATAIROUTLETNODE:System Node Humidity Ratio [kgWater/kgDryAir](TimeStep)",
    "WEST ZONE:Zone Thermostat Heating Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Thermostat Cooling Setpoint Temperature [C](TimeStep)",
    "WEST ZONE:Zone Air Temperature [C](TimeStep)",
    "ZONE1UNITHEATFAN:Fan Electricity Rate [W](TimeStep)",
    "ZONE1UNITHEATFAN:Fan Air Mass Flow Rate [kg/s](TimeStep)",
    "ZONE1UNITHEATFAN:Fan Heat Gain to Air [W](TimeStep)",
    "ZONE1UNITHEATFAN:Fan Runtime Fraction [](TimeStep)"
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=60,
    final_time=31536000)

if __name__ == '__main__':
    main()
