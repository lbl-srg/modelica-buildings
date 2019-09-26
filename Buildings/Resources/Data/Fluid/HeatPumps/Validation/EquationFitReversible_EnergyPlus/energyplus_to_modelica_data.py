#!/usr/bin/env python
# coding: utf-8
import os

import pandas as pd

def energyplus_to_modelica_data(file_path, timestep, data_type, file_name):
    '''
    Parameters:
    file_path: the file path of the existing energyplus data
    time_step: the time step of the energyplus data
    data_type: specify the data type such as float, double etc.
    file_name: the file name of the modelica data
    '''
    # read the existing energyplus data
    energyplus_data = pd.read_csv(file_path)
    # get the dimension of the matrix
    size = energyplus_data.shape
    # create a new index for modelica
    energyplus_data.index = (energyplus_data.index)*timestep
    energyplus_data.index.name = '# time'
    energyplus_data.drop(['Date/Time'], axis=1, inplace=True)

    # write to csv for modelica
    file = file_name + '.csv'
    with open(file,'w') as f:
        line1 = '#1'
        line2 = data_type + ' ' + file_name + '(' + str(size[0]) + ',' + str(size[1]) + ')'
        f.write('{}\n{}\n'.format(line1,line2))
        energyplus_data.to_csv(f, header=True)

file_path = os.path.abspath('GSHPSimple-GLHE-ReverseHeatPump.csv')
timestep =  60
data_type = 'float'
file_name = 'modelica'
energyplus_to_modelica_data(file_path, timestep, data_type, file_name)
