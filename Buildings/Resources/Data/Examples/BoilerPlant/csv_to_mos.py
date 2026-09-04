#!/usr/bin/env python3
import sys
sys.path.append('../../../../Scripts/EnergyPlus')
import energyplus_csv_to_mos as e

def check():
    args = sys.argv[1:]
    dat_fil = args[0].replace(".idf", ".dat")
    print(dat_fil)

def main(file_name):
    dat_fil = file_name.replace(".idf", ".dat")
    output_list =[
    'HHW return temperature',
    'HHW mass flowrate',
    'HHW supply temperature',
    'CHW supply temperature',
    'CHW mass flowrate',
    'CHW return temperature',
    'Min temp'
    ]

    e.energyplus_csv_to_mos(
    output_list = output_list,
    dat_file_name=dat_fil,
    step_size=3600,
    final_time=31536000)

if __name__ == '__main__':
    main('loads.idf')
