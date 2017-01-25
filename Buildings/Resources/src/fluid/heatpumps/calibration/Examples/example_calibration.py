# -*- coding: utf-8 -*-
""" Example calibration of the heat pump model.

This script demonstrates the use of the calibration module to obtain parameters
of the heat pump model. Data is loaded from a performance file generated in
dummy_performance_data.py. Once heat pump parameters are identified, the
results are verified by running the model in Dymola.

"""
from __future__ import division, print_function, absolute_import
import os
import sys


def main():
    # Add parent directory to system path
    parent_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    sys.path.insert(1, parent_dir)
    # Import Heat pump and calibration module
    import PythonModel as hp
    # Change working directory to current directory
    os.chdir(os.path.dirname(__file__))
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
            EWT_Source = float(dataPoint[0])
            EWT_Load = float(dataPoint[1])
            Flow_Source = float(dataPoint[2])
            Flow_Load = float(dataPoint[3])
            Capacity = float(dataPoint[4])
            HR = float(dataPoint[5])
            Power = float(dataPoint[6])
            # Add data point to Data object
            data.add_data_point(EWT_Source, EWT_Load, Flow_Source,
                                Flow_Load, Capacity, HR, Power)

    # Data points used in calibration
    calData = data.calibration_data_16_points()

    # Initialize the heat pump model
    P_nominal = 17.5e3
    Q_nominal = P_nominal*4.0

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

# Main function
if __name__ == "__main__":
    main()
