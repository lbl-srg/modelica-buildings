# -*- coding: utf-8 -*-
""" Example calibration of the heat pump model.

This script demonstrates the use of the calibration module to obtain parameters
of the heat pump model. Data is loaded from a performance file generated in
dummy_performance_data.py. Once heat pump parameters are identified, the
results are verified by running the model in Dymola. A modelica record of the
heat pump parameters is generated.

"""
from __future__ import division, print_function, absolute_import

import numpy as np
import os
import sys
import datetime


def main():
    # Add parent directory to system path
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    sys.path.insert(1, parent_dir)
    # Import Heat pump and calibration module
    import PythonModel as hp
    # Change working directory to current directory
    os.chdir(os.path.dirname(__file__))
    # Author info for record generation
    author = 'Mr Modeler'
    # Make and model of the heat pump
    manufacturer = 'SomeManufacturer'
    model = 'ABC060'
    # Set to True if calibrating for cooling mode
    CoolingMode = False
    # File name and table name for manufacturer data in modelica
    tableFileName = 'manufacturerData.txt'
    tableName = 'ManufacturerData'
    # File name for performance data
    performanceData = 'somePerformanceData.txt'

    # Load manufacturer data
    data = hp.calibrate.ManufacturerData(manufacturer, model, CoolingMode)
    with open(performanceData, 'r') as f:
        for line in f:
            dataPoint = line[0:-2].split('\t')
            EWT_Source = float(dataPoint[0])    # Entering water temperature evaporator (K)
            EWT_Load = float(dataPoint[1])      # Entering water temperature condenser (K)
            flowSource = float(dataPoint[2])    # Entering water flow rate evaporator (kg/s)
            flowLoad = float(dataPoint[3])      # Entering water flow rate condenser (kg/s)
            Capacity = float(dataPoint[4])      # Heat transfer rate on the load side (kW).
            HR = float(dataPoint[5])            # Heat transfer rate on the source side (kW).
            Power = float(dataPoint[6])         # Electrical power input to heat pump (kW)
            # Add data point to Data object
            data.add_data_point(EWT_Source, EWT_Load, flowSource,
                                flowLoad, Capacity, HR, Power)

    # Data points used in calibration
    calData = data.calibration_data_16_points()

    # Initialize the heat pump model
    P_nominal = 17.5e3
    COP_nominal = 4.0
    Q_nominal = P_nominal*COP_nominal

    # -------------------------------------------------------------------------
    # Initialize all models using a value of 0. for all parameters. Parameters
    # will be replaced by guess values at the start of the calibration process.
    # -------------------------------------------------------------------------
    # Compressor model (Scroll)
    com = hp.compressors.ScrollCompressor([0., 0., 0., 0., 0., 0.])
    # Condenser model
    con = hp.heatexchangers.EvaporatorCondenser([0.])
    # Evaporator model
    eva = hp.heatexchangers.EvaporatorCondenser([0.])
    # Refrigerant model
    ref = hp.refrigerants.R410A()
    # Fluid model on condenser side
    fluCon = hp.fluids.ConstantPropertyWater()
    # Fluid model on evaporator side
    fluEva = hp.fluids.ConstantPropertyWater()
    # Heat pump model
    heaPum = hp.heatpumps.SingleStageHeatPump(com, con, eva, ref, fluCon,
                                              fluEva, Q_nominal, P_nominal,
                                              CoolingMode)

    # Lauch the calibration of the heat pump model.
    optPar, optRes, gueRes = hp.calibrate.calibrate_model(heaPum, calData,
                                                          data, plot=True)

    # Write the results into a record for use in Modelica
    write_record_scroll(author, manufacturer, model, CoolingMode,
                        'R410A', Q_nominal, COP_nominal,
                        optPar)

    # -------------------------------------------------------------------------
    # Calculate heat pump performance for full dataset in Dymola using the
    # calibrated parameters.
    # -------------------------------------------------------------------------
    dymRes = hp.calibrate.simulate_in_dymola(heaPum, data, tableName,
                                             tableFileName)
    SSE = hp.calibrate.compare_data_sets(dymRes, data, plot=True,
                                         fname=data.name + '_dymola')
    print('----------------------------------------------------------------\n')
    print('Sum of square errors (dymola) : ' + str(SSE) + ' \n')
    print('----------------------------------------------------------------\n')

    # Compare the results of the Python code with the results from Dymola.
    SSE = hp.calibrate.compare_data_sets(dymRes, optRes, plot=True,
                                         fname='modelVerification')
    return optRes, dymRes


def write_record_scroll(author, manufacturer, model, CoolingMode,
                        refrigerant, Q_nominal, COP_nominal,
                        optPar):
    # Evaluate current date
    date = str(datetime.date.today())

    # Extract heat pump parameters from optimized results
    volRat = optPar[0]     # Built-in volume ratio (-)
    v_flow = optPar[1]     # Volume flow rate at suction (m3/s)
    leaCoe = optPar[2]     # Leakage coefficient (kg/s)
    etaEle = optPar[3]     # Electro-mechanical efficiency (-)
    PLos = optPar[4]       # Constant part of the power losses (W)
    dTSup = optPar[5]      # Amplitude of superheating (K)
    UACon = optPar[6]      # Thermal conductance of the condenser (W/K)
    UAEva = optPar[7]      # Thermal conductance of the evaporator (W/K)

    # Operation mode
    if CoolingMode:
        mode = 'Cooling'
    else:
        mode = 'Heating'

    # Build string for nominal capacity. If less than 10kW, the nominal
    # capacity is printed with the first decimal (ex. 9.1kW -> 9_1kW)
    # otherwise the capacity is rounded (ex. 10.6kW - > 11kW).
    if Q_nominal < 10.0e3:
        Q_str = (str(int(Q_nominal/1.0e3)) +
                 '_' +
                 str(int(round(10.*(Q_nominal-np.floor(Q_nominal))/1.0e3))))
    else:
        Q_str = str(int(Q_nominal/1.0e3))

    # Build the full name of the record, including the manufacturer, model,
    # nominal capacity, nominal COP (keeping 2 decimals) and refrigerant type.
    name = '_'.join([manufacturer,
                     model,
                     Q_str + 'kW',
                     str(int(COP_nominal)),
                     str(int(round(100.*(COP_nominal
                                         -np.floor(COP_nominal))))) + 'COP',
                     refrigerant])
    path = name + '.mo'

    # Print the record in Modelica format.
    with open(path, 'w') as f:
        f.write('within Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.'
                + mode + ';\n')
        f.write('record ' + name + ' =\n')
        f.write('  Buildings.Fluid.HeatPumps.Data.ScrollWaterToWater.Generic ('
                + '\n')
        f.write('    volRat = ' + str(volRat) + ',\n')
        f.write('    V_flow_nominal = ' + str(v_flow) + ',\n')
        f.write('    leaCoe = ' + str(leaCoe) + ',\n')
        f.write('    etaEle = ' + str(etaEle) + ',\n')
        f.write('    PLos = ' + str(PLos) + ',\n')
        f.write('    dTSup = ' + str(dTSup) + ',\n')
        f.write('    UACon = ' + str(UACon) + ',\n')
        f.write('    UAEva = ' + str(UAEva) + ')\n\n')

        f.write('  annotation (\n')
        f.write('    defaultComponentPrefixes = "parameter",\n')
        f.write('    defaultComponentName="datHeaPum",\n')
        f.write('    preferredView="info",\n')
        f.write('  Documentation(info="<html>\n')
        f.write('<p>\n')
        f.write('Generated by ' + author + ' on ' + date + '.\n')
        f.write('</p>\n')
        f.write('</html>"));')
    return

# Main function
if __name__ == "__main__":
    main()
