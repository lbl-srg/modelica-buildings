#!/usr/bin/env python3
# coding: utf-8
import os
import pandas as pd
import numpy as np

def _convert(timestep, file_name):
    # read the whole data set
    energyplus_output = pd.read_csv(os.path.join('EnergyPlus', 'eplusout.csv'))
    # [PEleDem (H), mWat_flow (), TWat_in (R), TRoo (V), PEleNet (H), QGro (L), GGen (M), GWat (U, S, R), QLos (T), TWatOut (S), TEng (Q), TWatOutSet ()]
    # [H, R, V, L, M, S, T, Q, U]
    # [H, L, M, Q, R, S, T, U, V]
    column_head=['MICROCOGEN1:Generator Produced AC Electricity Rate [W](TimeStep)', 'MICROCOGEN1:Generator Gross Input Heat Rate [W](TimeStep)',
                 'MICROCOGEN1:Generator Steady State Engine Heat Generation Rate [W](TimeStep)', 'MICROCOGEN1:Generator Engine Temperature [C](TimeStep)',
                 'MICROCOGEN1:Generator Coolant Inlet Temperature [C](TimeStep)', 'MICROCOGEN1:Generator Coolant Outlet Temperature [C](TimeStep)',
                 'MICROCOGEN1:Generator Zone Sensible Heat Transfer Rate [W](TimeStep)', 'MICROCHP SENERTECH PUMP-MICROCOGEN1NODE:System Node Mass Flow Rate [kg/s](TimeStep)',
                 'ZN_1_FLR_1_SEC_4:Zone Mean Air Temperature [C](TimeStep)', 'MICROCOGEN1:Generator Warm Up Mode Time [s](TimeStep)',
                 'MICROCOGEN1:Generator Cool Down Mode Time [s](TimeStep)', 'MICROCOGEN1:Generator Electric Efficiency [](TimeStep)']
    variblesName = ['proElePow', 'groInpHea', 'engHeaGen', 'engTem', 'watInTem', 'watOutTem', 'zonSenHeaTra', 'masFloRat', 'zonAirTem', 'warUp', 'cooDow', 'eleEff']
    results = {}
    for i in range(len(column_head)):
        results.update({variblesName[i] : energyplus_output.loc[:, column_head[i]].to_numpy()})
    dataLen = len(results['proElePow'])

    outputs = list()
    # ['time', 'PEleDem', 'mWat_flow', 'TWat_in', 'TRoo', 'PEleNet', 'QGro', 'QGen', 'QWat', 'QLos', 'TWatOut', 'TEng', 'TWatOutSet']

    time = np.zeros(dataLen + 1)
    for i in range(dataLen + 1):
        time[i] = i * timestep
    outputs.append({'variable': 'time', 'value': time})

    # -----------
    PEleDem = np.zeros(dataLen + 1)
    PEleDem[0] = results['proElePow'][0]
    for i in range(dataLen):
        if results['warUp'][i] < 1:
            PEleDem[i+1] = results['proElePow'][i]
        else:
            PEleDem[i+1] = results['eleEff'][i] * results['groInpHea'][i]
    outputs.append({'variable': 'PEleDem', 'value': PEleDem})

    # -----------
    mWat_flow = np.zeros(dataLen + 1)
    for i in range(dataLen):
        if (PEleDem[i+1] > 0 or results['cooDow'][i] > 1):
            mWat_flow[i+1] = 0.4
        else:
            mWat_flow[i+1] = 0
    mWat_flow[0] = mWat_flow[1]
    outputs.append({'variable': 'mWat_flow', 'value': mWat_flow})

    # -----------
    variables1 = ['TWat_in', 'TRoo', 'PEleNet', 'QGro', 'QGen']
    data1 = ['watInTem', 'zonAirTem', 'proElePow', 'groInpHea', 'engHeaGen']
    for i in range(len(variables1)):
        outputs.append(_data_dictionary(results, dataLen, data1[i], variables1[i]))

    # -----------
    QWat = np.zeros(dataLen + 1)
    for i in range(dataLen):
        QWat[i+1] = 4180 * results['masFloRat'][i] * (results['watOutTem'][i] - results['watInTem'][i])
    QWat[0] = QWat[1]
    outputs.append({'variable': 'QWat', 'value': QWat})

    # -----------
    variables2 = ['QLos', 'TWatOut', 'TEng']
    data2 = ['zonSenHeaTra', 'watOutTem', 'engTem']
    for i in range(len(variables2)):
        outputs.append(_data_dictionary(results, dataLen, data2[i], variables2[i]))

    # -----------
    TWatOutSet = np.zeros(dataLen + 1)
    for i in range(dataLen):
        if (PEleDem[i+1] > 0):
            TWatOutSet[i+1] = results['watOutTem'][i]
        else:
            TWatOutSet[i+1] = 0
    TWatOutSet[0] = TWatOutSet[1]
    outputs.append({'variable': 'TWatOutSet', 'value': TWatOutSet})
    _print_to_file(outputs, file_name)

def _data_dictionary(results, data_length, data_variable, variable):
    temp = np.zeros(data_length + 1)
    temp[1:] = results[data_variable]
    temp[0] = temp[1]
    return {'variable': variable, 'value': temp}

def _print_to_file(data_list, file_name):
    headText = '''#1
#Two days (01/21, 07/21) Energy plus simulation results by running exmple "MicroCogeneration.idf",
#1st column: Time, seconds in two days
#2nd column: PEleDem, demand electric power, [w]
#3rd column: mWat_flow, generator cooling water flow rate, [kg/s]
#4th column: TWatIn, generator cooling water inlet temperature, [degC]
#5th column: TRoo, zone mean air temperature, [degC]
#6th column: PEleNet, generator produced electric power, [w]
#7th column: QGro_flow, generator gross input heat rate, [w]
#8th column: QGen_flow, generator steady state engine heat generation rate, [w]
#9th column: QWat_flow, heat rate transferred to cooling water, [w]
#10th column: QLos_flow, generator zone sensible heat transfer rate, [w]
#11th column: TWatOut, generator cooling water outlet temperature, [degC]
#12th column: TEng, generator engine temperature, [degC]
#13th column: TWatOutSet, generator cooling water setpoint temperaure, (if PEleDem>0, TWatOut, else 0), [degC]
double tab1(2881,13)
'''
    with open(file_name, 'w') as f:
        f.write('{}'.format(headText))
        for i in range(len(data_list[0]['value'])):
            for j in range(len(data_list) - 1):
                f.write('{:.2f},'.format(data_list[j]['value'][i]))
            f.write('{:.2f}\n'.format(data_list[-1]['value'][i]))


timestep =  60
file_name = 'MicroCogeneration.mos'
_convert(timestep, file_name)
