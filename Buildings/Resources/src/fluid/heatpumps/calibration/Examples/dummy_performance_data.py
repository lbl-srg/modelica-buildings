# -*- coding: utf-8 -*-
""" Example use of the heat pump model to generate performance data.

This script demonstrates the use of the heat pump model to generate performance
data. Data is generated for a heat pump with a scroll compressor and some
combinations of inlet water temperatures and mass flow rates on the source
and load sides. The resulting performance data is written to a text file.

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
    # Set to True if calibrating for cooling mode
    CoolingMode = False
    # File name for performance data
    tableFileName = 'somePerformanceData.txt'

    # Initialize the heat pump model
    P_nominal = 17.5e3         # Nominal heat pump power input (W).
    COP_nominal = 4.0          # Nominal COP of the heat pump (-)
    Q_nominal = P_nominal*COP_nominal  # Nominal heat pump capacity (W).

    # Model parameters
    volRat = 2.365             # Volume ratio (-).
    V_flow_nominal = 0.00288   # Nominal refrigerant volume flow rate (kg/s).
    leaCoe = 0.0041            # Leakage coefficient (kg/s)
    etaEle = 0.924             # Elctro-mechanical efficiency (-).
    PLos = 396.1               # Constant part of the power losses (W).
    dTSup = 6.84               # Degree of superheating (K).
    UACon = 7007.7             # Condenser heat transfer coefficient (W/K).
    UAEva = 29990.9            # Evaporator heat transfer coefficient (W/K).

    # Boundary conditions
    # Source-side water mass flow rates (L/s)
    mSou_flow = [0.6, 0.9, 1.2]
    # Load-side water mass flow rates (L/s)
    mLoa_flow = [0.6, 0.9, 1.2]
    # Source-side entering water temperatures (K)
    TSou = [273.15, 278.15, 283.15, 288.15, 293.15, 298.15]
    # Load-side entering water temperatures (K)
    TLoa = [288.15, 298.15, 308.15, 318.15]

    # -------------------------------------------------------------------------
    # Initialize all models using given parameters values.
    # -------------------------------------------------------------------------
    # Compressor model (Scroll)
    com = hp.compressors.ScrollCompressor([volRat,
                                           V_flow_nominal,
                                           leaCoe,
                                           etaEle,
                                           PLos,
                                           dTSup])
    # Condenser model
    con = hp.heatexchangers.EvaporatorCondenser([UACon])
    # Evaporator model
    eva = hp.heatexchangers.EvaporatorCondenser([UAEva])
    # Refrigerant model
    ref = hp.refrigerants.R410A()
    # Fluid model on condenser side
    fluCon = hp.fluids.ConstantPropertyWater()
    # Fluid model on evaporator side
    fluEva = hp.fluids.ConstantPropertyWater()
    # Heat pump model
    heaPum = hp.heatpumps.SingleStageHeatPump(
        com, con, eva, ref, fluCon, fluEva, Q_nominal, P_nominal, CoolingMode)

    # -------------------------------------------------------------------------
    # Evaluate heat pump peformance at all combinations of boundary conditions.
    # -------------------------------------------------------------------------
    with open(tableFileName, 'w') as f:
        for TS in TSou:
            for mS in mSou_flow:
                for TL in TLoa:
                    for mL in mLoa_flow:
                        # Evaluate capacity, source-side heat transfer rate and
                        # power input.
                        Cap = heaPum.get_Capacity(TS, TL, mS, mL)/1e3
                        HR = heaPum.get_SourceSideTransferRate(TS, TL, mS, mL)/1e3
                        Power = heaPum.get_Power(TS, TL, mS, mL)/1e3
                        # Write to text file.
                        f.write('{}\t{}\t{}\t{}\t{}\t{}\t{}\n'.format(
                                TS, TL, mS, mL, Cap, HR, Power))
    return

# Main function
if __name__ == '__main__':
    main()
