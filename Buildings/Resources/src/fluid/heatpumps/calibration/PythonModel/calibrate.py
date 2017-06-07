from __future__ import division, print_function, absolute_import

from builtins import str
import matplotlib.pyplot as plt
import numpy as np
import os
from scipy.optimize import minimize
import time as tm


def calibrate_model(heaPum, calData, data, plot=True):
    """ Manages the calibration of heat pump models.

    :param heaPum: Heat pump model (object).
    :param calData: Subsampled data used for calibration (object).
    :param data: Full data used for final comparison (object).
    :param plot: Boolean, set to True to draw and save results.

    :return: List of calibrated parameters,
             Results from the calibrated model,
             Results using the initial guess parameters.

    """
    # Select appropriate guess values for model parameters and bounds for
    # calibration
    params, bounds = heaPum.initialGuessParameters(data)
    heaPum.reinitializeParameters(params)

    # Normalized values of the parameters
    scale = params / params
    # Normalized bounds for calibration
    scale_bounds = [(bounds[i][0]/params[i], bounds[i][1]/params[i])
                    if bounds[i][1] is not None
                    else (bounds[i][0]/params[i], None)
                    for i in range(len(bounds))]

    tic = tm.time()
    # Compare and plot comparison with manufacturer data for guess parameters
    gueRes = simulate(heaPum, data)

    if data.CoolingMode:
        fname = data.name + '_Cooling'
    else:
        fname = data.name + '_Heating'
    compare_data_sets(gueRes, data, plot, fname=fname + '_opt_start')

    # Calibrate the model parameters
    opt = minimize(cost_function, scale, args=(params, heaPum, calData),
                   method='SLSQP', bounds=scale_bounds,
                   options={'maxiter': 2000, 'ftol': 1e-8, 'eps': 0.00001})

    # Compare and plot comparison with manufacturer data for calibrated
    # parameters
    optPar = opt.x*params
    heaPum.reinitializeParameters(optPar)
    optRes = simulate(heaPum, data)
    compare_data_sets(optRes, data, plot, fname=fname + '_opt_end')
    toc = tm.time() - tic
    print('Total elapsed time for calibration : %f seconds' % toc)
    return optPar, optRes, gueRes


def compare_data_sets(data, refData, plot=False, fname='ComparedDataSets'):
    """ Compare two sets of data.

    :param data: Performance data (object).
    :param refData: Reference performance data (object).
    :param plot: Boolean, set to True to draw and save results.
    :param fname: Name of the output figure file (no extension).

    :return: Sum of normalized square errors between data sets.

    """
    fname += '.pdf'

    SSE = 0.0
    invalidPoints = 0.
    totalPoints = float(len(data.EWT_Source))
    # Evaluate the power and capacity for each data point in provided
    # manufacturer data set
    for i in range(len(refData.EWT_Load)):
        if not (data.Power[i] > 0. and data.Capacity[i] > 0.):
            invalidPoints += 1.
            print ('Invalid : EWT_Source =', data.EWT_Source[i],
                   'EWT_Load = ', data.EWT_Load[i],
                   'flowSource = ', data.flowSource[i],
                   'flowLoad = ', data.flowLoad[i])
        # Calculate the sum of square errors
        SE = ((refData.Power[i]-data.Power[i])/refData.Power[i])**2 \
            + ((refData.Capacity[i]-data.Capacity[i])/refData.Capacity[i])**2
        SSE += SE
    print('Number of invalid points :', invalidPoints)

    # Plot the results (optional)
    if plot:
        fig = plt.figure()
        ax = fig.add_subplot(121)
        ax.plot(np.array([0, max(refData.Power)]),
                np.array([0, 0.9*max(refData.Power)]), 'b--')
        ax.plot(np.array([0, max(refData.Power)]),
                np.array([0, 1.1*max(refData.Power)]), 'b--')
        ax.plot(np.array([0, max(refData.Power)]),
                np.array([0, 1*max(refData.Power)]), 'k-')
        ax.text(0.75*max(refData.Power),
                0.9*0.75*max(refData.Power),
                '-10%',
                verticalalignment='top',
                horizontalalignment='left',
                weight='bold')
        ax.text(0.75*max(refData.Power),
                1.1*0.75*max(refData.Power),
                '+10%',
                verticalalignment='bottom',
                horizontalalignment='right',
                weight='bold')
        ax.plot(refData.Power, data.Power, 'k.')
        ax.set_xlabel('Power (' + refData.name + ') [kW]')
        ax.set_ylabel('Power (' + data.name + ') [kW]')
        ax.grid(True)
        ax = fig.add_subplot(122)
        ax.plot(np.array([0, max(refData.Capacity)]),
                np.array([0, 0.9*max(refData.Capacity)]), 'b--')
        ax.plot(np.array([0, max(refData.Capacity)]),
                np.array([0, 1.1*max(refData.Capacity)]), 'b--')
        ax.plot(np.array([0, max(refData.Capacity)]),
                np.array([0, 1*max(refData.Capacity)]), 'k-')
        ax.text(0.75*max(refData.Capacity),
                0.9*0.75*max(refData.Capacity),
                '-10%',
                verticalalignment='top',
                horizontalalignment='left',
                weight='bold')
        ax.text(0.75*max(refData.Capacity),
                1.1*0.75*max(refData.Capacity),
                '+10%',
                verticalalignment='bottom',
                horizontalalignment='right',
                weight='bold')
        ax.plot(refData.Capacity, data.Capacity, 'k.')
        ax.set_xlabel('Capacity (' + refData.name + ') [kW]')
        ax.set_ylabel('Capacity (' + data.name + ') [kW]')
        ax.grid(True)
        plt.savefig(fname)

    return SSE


def cost_function(scale, guess, heaPum, data):
    """ Evaluate the cost function for optimization.

    :param scale: Array of normalized parameters.
    :param guess: Array of guess parameters.
    :param heaPum: Heat pump model (object).
    :param data: Reference performance data (object).

    :return: Sum of normalized square errors between model and reference data.

    .. note:: Parameters are evaluated by multiplying the corresponding
              normalized parameter with its guess value.

    """
    # Scale the normalized parameters back to dimensional values
    params = guess*scale

    print('----------------------------------------------------------------\n')
    heaPum.reinitializeParameters(params)
    heaPum.printParameters()
    print('----------------------------------------------------------------\n')

    res = simulate(heaPum, data)
    SSE = compare_data_sets(res, data)

    print('Sum of square errors : ' + str(SSE) + ' \n')
    print('----------------------------------------------------------------\n')
    return SSE


def simulate(heaPum, data):
    """ Evaluate the heat pump performance from the model.

    :param heaPum: Heat pump model (object).
    :param data: Reference performance data (object).

    :return: Performance data of the modeled heat pump (object).

    .. note:: Performance data from the model is evaluated at the same
              operating conditions (inlet water temperatures and mass flow
              rates at the source and load sides) as in the reference data.

    """
    Capacity = np.zeros(len(data.EWT_Load))
    HR = np.zeros(len(data.EWT_Load))
    P = np.zeros(len(data.EWT_Load))
    # Evaluate the power and capacity for each data point in provided
    # manufacturer data set
    for i in range(len(data.EWT_Load)):
        Capacity[i] = heaPum.get_Capacity(data.EWT_Source[i],
                                          data.EWT_Load[i],
                                          data.flowSource[i],
                                          data.flowLoad[i])
        HR[i] = heaPum.get_SourceSideTransferRate(data.EWT_Source[i],
                                                  data.EWT_Load[i],
                                                  data.flowSource[i],
                                                  data.flowLoad[i])
        P[i] = heaPum.get_Power(data.EWT_Source[i], data.EWT_Load[i],
                                data.flowSource[i], data.flowLoad[i])

    res = SimulationResults(data.EWT_Source, data.EWT_Load, data.flowSource,
                            data.flowLoad, Capacity, HR, P, 'Python model')
    return res


def simulate_in_dymola(heaPum, data, tableName, tableFileName):
    """ Evaluate the heat pump performance from the model in Dymola.

    :param heaPum: Heat pump model (object).
    :param data: Reference performance data (object).
    :param tableName: Name of the combiTimeTable.
    :param tableFileName: Name of the text file containing the combiTimeTable.

    :return: Performance data of the modeled heat pump (object).

    .. note:: Performance data from the model is evaluated at the same
              operating conditions (inlet water temperatures and mass flow
              rates at the source and load sides) as in the reference data.

    """
    import buildingspy.simulate.Simulator as si
    from buildingspy.io.outputfile import Reader
    from scipy.interpolate import interp1d
    from builtins import str
    import getpass
    import os
    import tempfile

    # Find absolute path to buildings library
    packagePath = os.path.normpath(
        os.path.join(os.path.normpath(os.path.dirname(__file__)),
                     '..', '..', '..', '..', '..', '..'))

    # Create temporary directory for simulation files
    dirPrefix = tempfile.gettempprefix()
    tmpDir = tempfile.mkdtemp(prefix=dirPrefix + '-'
                              + 'HeatPumpCalibration' + '-'
                              + getpass.getuser() + '-')

    # Set parameters for simulation in Dymola
    calModelPath = heaPum.modelicaCalibrationModelPath()
    s = si.Simulator(calModelPath,
                     'dymola',
                     outputDirectory=tmpDir,
                     packagePath=packagePath)
    s = heaPum.set_ModelicaParameters(s)
    m1_flow_nominal = min(data.flowSource)
    m2_flow_nominal = min(data.flowLoad)
    tableFilePath = \
        str(os.path.join(tmpDir, tableFileName).replace(os.sep, '/'))
    s.addParameters({'m1_flow_nominal': m1_flow_nominal,
                     'm2_flow_nominal': m2_flow_nominal,
                     'calDat.fileName': tableFilePath})

    # Write CombiTimeTable for dymola
    data.write_modelica_combiTimeTable(tableName, tmpDir,
                                       tableFileName, heaPum.CoolingMode)

    # Simulation parameters
    s.setStopTime(len(data.EWT_Source))
    s.setSolver('dassl')
    # Kill the process if it does not finish in 2 minutes
    s.setTimeOut(120)
    s.showProgressBar(False)
    s.printModelAndTime()
#    s.showGUI(show=True)
#    s.exitSimulator(exitAfterSimulation=False)
    s.simulate()

    # Read results
    modelName = heaPum.modelicaModelName()
    ofr = Reader(os.path.join(tmpDir, modelName), 'dymola')
    (time1, QCon) = ofr.values('heaPum.QCon_flow')
    (time1, QEva) = ofr.values('heaPum.QEva_flow')
    (time1, P) = ofr.values('heaPum.P')

    t = [float(i) + 0.5 for i in range(len(data.EWT_Source))]

    f_P = interp1d(time1, P)
    P = f_P(t)
    f_QCon = interp1d(time1, QCon)
    QCon = f_QCon(t)
    f_QEva = interp1d(time1, QEva)
    QEva = f_QEva(t)

#    # Clean up
#    shutil.rmtree('calibrationModel')
    if heaPum.CoolingMode:
        Capacity = -QEva
        HR = QCon
    else:
        Capacity = QCon
        HR = -QEva
    dymRes = SimulationResults(data.EWT_Source,
                               data.EWT_Load,
                               data.flowSource,
                               data.flowLoad,
                               Capacity,
                               HR,
                               P,
                               'Modelica')
    return dymRes


class ManufacturerData(object):
    """ Heat pump performance data.

    :param manufacturer: Name of the manufacturer.
    :param model: Name of the heat pump model.
    :param CoolingMode: Boolean, set to True if heat pump is used in cooling
                        mode.

    .. note:: An empty heat pump performance object is created.

    """
    def __init__(self, manufacturer, model, CoolingMode=False):
        self.EWT_Source = []
        self.EWT_Load = []
        self.flowSource = []
        self.flowLoad = []
        self.Capacity = []
        self.HR = []
        self.Power = []
        self.name = manufacturer + '_' + model
        self.CoolingMode = CoolingMode

    def add_data_point(self, EWT_Source, EWT_Load, flowSource,
                       flowLoad, Capacity, HR, Power):
        """ Add a data point to the heat pump performance data.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).
        :param Capacity: Heat pump capacity (kW).
        :param HR: Heat transfer rate on the source side (kW).
        :param Power: Power input to the heat pump (kW).

        """
        self.EWT_Source.append(EWT_Source)
        self.EWT_Load.append(EWT_Load)
        self.flowSource.append(flowSource)
        self.flowLoad.append(flowLoad)
        self.Capacity.append(Capacity)
        self.HR.append(HR)
        self.Power.append(Power)
        return

    def calibration_data_16_points(self):
        """ Find the 16 min/max data points.

        :return: Performance data for calibration (object).

        .. note:: This method returns a subsample of the performance data
                  corresponding to the combination of minimums and maximums of
                  the inlet water temperatures and mass flow rates on the
                  source and load sides.

        """
        # Only the 16 extreme data points for temperature and flow rates
        # are used
        indexes = range(len(self.EWT_Source))
        variables = [self.flowLoad, self.EWT_Source,
                     self.EWT_Load, self.flowSource]
        li = [indexes]
        # Go through the data for each variable and keep indexes corresponding
        # to min/max values
        for i in range(len(variables)):
            jmin = len(li)-(2**(i))
            jmax = len(li)
            for j in range(jmin, jmax):
                minValue = min([variables[i][k] for k in li[j]])
                maxValue = max([variables[i][k] for k in li[j]])
                li.append([k for k in li[j] if variables[i][k] == minValue])
                li.append([k for k in li[j] if variables[i][k] == maxValue])
        indexes = []
        jmin = len(li)-(2**4)
        jmax = len(li)
        for j in range(jmin, jmax):
            indexes += li[j]

        EWT_Source = np.array([self.EWT_Source[i] for i in indexes])
        EWT_Load = np.array([self.EWT_Load[i] for i in indexes])
        flowSource = np.array([self.flowSource[i] for i in indexes])
        flowLoad = np.array([self.flowLoad[i] for i in indexes])
        Capacity = np.array([self.Capacity[i] for i in indexes])
        HR = np.array([self.HR[i] for i in indexes])
        Power = np.array([self.Power[i] for i in indexes])
        calData = SimulationResults(EWT_Source, EWT_Load, flowSource,
                                    flowLoad, Capacity*1e3, HR*1e3,
                                    Power*1e3, self.name)
        return calData

    def calibration_data_min_max_temp(self):
        """ Find the data points that correspond to the minimum and maximum
            inlet water temperature on the source and load sides.

        :return: Performance data for calibration (object).

        .. note:: This method returns a subsample of the performance data
                  corresponding to the combination of minimums and maximums of
                  the inlet water temperatures on the source and load sides.

        """
        # All the data corresponding to min/max source and load temperatures
        # are used
        indexes = range(len(self.EWT_Source))
        variables = [self.EWT_Source, self.EWT_Load]
        li = [indexes]
        # Go through the data and keep indexes corresponding
        # to min/max values of source and load temperatures
        for i in range(len(variables)):
            jmin = len(li)-(2**(i))
            jmax = len(li)
            for j in range(jmin, jmax):
                minValue = min([variables[i][k] for k in li[j]])
                maxValue = max([variables[i][k] for k in li[j]])
                li.append([k for k in li[j] if variables[i][k] == minValue])
                li.append([k for k in li[j] if variables[i][k] == maxValue])
        indexes = []
        jmin = len(li)-(2**2)
        jmax = len(li)
        for j in range(jmin, jmax):
            indexes += li[j]

        EWT_Source = np.array([self.EWT_Source[i] for i in indexes])
        EWT_Load = np.array([self.EWT_Load[i] for i in indexes])
        flowSource = np.array([self.flowSource[i] for i in indexes])
        flowLoad = np.array([self.flowLoad[i] for i in indexes])
        Capacity = np.array([self.Capacity[i] for i in indexes])
        HR = np.array([self.HR[i] for i in indexes])
        Power = np.array([self.Power[i] for i in indexes])
        calData = SimulationResults(EWT_Source, EWT_Load, flowSource,
                                    flowLoad, Capacity*1e3, HR*1e3,
                                    Power*1e3, self.name)
        return calData

    def write_modelica_combiTimeTable(self, tableName, tableTempDir,
                                      tableFileName, CoolingMode):
        """ Write the combiTimeTable for use by the calibration model in
            Modelica.

        :param tableName: Name of the combiTimeTable.
        :param tableTempDir: Temporary directory to write the table file.
        :param tableFileName: Name of the text file containing the
                              combiTimeTable.
        :param CoolingMode: Boolean, set to True if heat pump is used in
                            cooling mode.

        """
        if not os.path.exists(tableTempDir):
            os.makedirs(tableTempDir)
        f = open(os.path.join(tableTempDir, tableFileName), 'w')
        f.write('#1\n')
        f.write('double '
                + tableName
                + '(' + str(2*len(self.EWT_Source)) + ',5)\n')
        if CoolingMode:
            for i in range(len(self.EWT_Source)):
                for j in [i, i + 1]:
                    f.write('\t'
                            + str(j)
                            + '\t' + str(self.EWT_Load[i])
                            + '\t' + str(self.EWT_Source[i])
                            + '\t' + str(self.flowLoad[i])
                            + '\t' + str(self.flowSource[i]) + '\n')
        else:
            for i in range(len(self.EWT_Source)):
                for j in [i, i + 1]:
                    f.write('\t'
                            + str(j)
                            + '\t' + str(self.EWT_Source[i])
                            + '\t' + str(self.EWT_Load[i])
                            + '\t' + str(self.flowSource[i])
                            + '\t' + str(self.flowLoad[i]) + '\n')
        f.close()
        return


class SimulationResults(object):
    """ Results from the simulation model.

        :param EWT_Source: Array of entering water temperature on the source
                           side (K).
        :param EWT_Load: Array of entering water temperature on the load
                         side (K).
        :param flowSource: Array of fluid mass flow rate on the source
                            side (kg/s).
        :param flowLoad: Array of fluid mass flow rate on the load
                          side (kg/s).
        :param Capacity: Array of heat pump capacity (W).
        :param HR: Array of heat transfer rate on the source side (W).
        :param Power: Array of power input to the heat pump (W).
        :param name: Name of the heat pump.

    """
    def __init__(self, EWT_Source, EWT_Load, flowSource, flowLoad,
                 Capacity, HR, Power, name):
        self.EWT_Source = EWT_Source
        self.EWT_Load = EWT_Load
        self.flowSource = flowSource
        self.flowLoad = flowLoad
        self.Capacity = Capacity*1e-3
        self.HR = HR*1e-3
        self.Power = Power*1e-3
        self.name = name


def _convert_FtoK(T):
    """ convert Fahrenheit to Kelvin.

    :param T: Temperature (F).

    :return: Temperature (K).

    """
    return (T - 32.0)*5.0/9.0 + 273.15


def _convert_GPMtoLPS(V):
    """ convert gal/min to L/s.

    :param V: Volume flow rate (gal/min).

    :return: Volume flow rate (L/s).

    """
    return V / 15.850372483753


def _convert_MBTUHtoKW(Q):
    """ convert MBtu/h to kW.

    :param Q: Power (MBtu/h).

    :return: Power (kW).

    """
    return Q * 0.29307107


def _convert_MBTUHtoW(Q):
    """ convert MBtu/h to W.

    :param Q: Power (MBtu/h).

    :return: Power (W).

    """
    return Q * 0.29307107e3
