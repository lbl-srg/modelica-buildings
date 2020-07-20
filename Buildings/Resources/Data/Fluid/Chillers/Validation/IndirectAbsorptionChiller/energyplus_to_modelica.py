#!/usr/bin/env python3
# coding: utf-8
import os
import pandas as pd

def _convert(file_path, timestep, data_type, file_name):
    # read the whole data set
    energyplus_output = pd.read_csv(os.path.join('EnergyPlus', 'eplusout.csv'))
    # round the data command
    energyplus_output= energyplus_output.round(4)
    # copy the first line
    energyplus_1min= energyplus_output.loc[[0],:]
    energyplus_output = pd.concat([energyplus_output,energyplus_1min]).sort_index()
    # reset index
    energyplus_output = energyplus_output.reset_index(drop=True)
    energyplus_output.columns= ['Date/Time','Pump [W]','QEva_flow [W]','TEvaEnt [K]','TEvaLvg [K]','mEva_flow [kg/s]','QCon_flow [W]','TConEnt [K]','TConLvg [K]','mEva_flow [kg/s]','QGen_flow [W]','QSteLoss [W]']
    new = energyplus_output.loc[:,['TEvaEnt [K]','TEvaLvg [K]','TConEnt [K]','TConLvg [K]']] + float(273.15)
    energyplus_output.update(new)
    # evaluate dimensions of the matrix
    size = energyplus_output.shape
    # modifiy the index for modelica mos
    energyplus_output.index = (energyplus_output.index)*timestep
    energyplus_output.index.name = '# time'
    energyplus_output.drop(['Date/Time'], axis=1, inplace=True)
    # write to csv for modelica
    file = file_name + '.csv'
    with open(file,'w') as f:
        line1 = '#1'
        line2 = data_type + ' ' + file_name + '(' + str(size[0]) + ',' + str(size[1]) + ')'
        f.write('{}\n' '{}\n'.format(line1,line2))
        energyplus_output.to_csv(f, header=True)

file_path = os.path.abspath('modelica.csv')
timestep =  60
data_type = 'float'
file_name = 'modelica'
_convert(file_path, timestep, data_type, file_name)
