#!/usr/bin/env python
# coding: utf-8
import os
import pandas as pd
# read the whole data set
energyplus_output = pd.read_csv('IndirectAbsorptionChiller.csv')
#round the data command
energyplus_output= energyplus_output.round(6)
# copy the first line
energyplus_1min= energyplus_output.loc[[0],:]
energyplus_new = pd.concat([energyplus_output,energyplus_1min]).sort_index()
# reset index
energyplus_new = energyplus_new.reset_index(drop=True)
# modelica file. mos preparation
def energyplus_to_modelica_data(file_path, timestep, data_type, file_name):
    '''
    Parameters:
    file_path: the file path of the existing energyplus data
    time_step: the time step of the energyplus data
    data_type: specify the data type such as float, double etc.
    file_name: the file name of the modelica data
    '''       
# evaluate dimensions of the matrix
    size = energyplus_new.shape 
# modifiy the index for modelica mos 
    energyplus_new.index = (energyplus_new.index)*timestep
    energyplus_new.index.name = '# time'
    energyplus_new.drop(['Date/Time'], axis=1, inplace=True) 
# write to csv for modelica
    file = file_name + '.csv'
    
    with open(file,'w') as f:
        line1 = '#1'
        line2 = data_type + ' ' + file_name + '(' + str(size[0]) + ',' + str(size[1]) + ')'
        f.write('{}\n' '{}\n'.format(line1,line2))
        energyplus_new.to_csv(f, header=True)

file_path = os.path.abspath('IndirectAbsorptionChiller.csv')
timestep =  60
data_type = 'float'
file_name = 'modelica'
energyplus_to_modelica_data(file_path, timestep, data_type, file_name)  
