from __future__ import division, print_function, absolute_import

import numpy as np


class SingleStageHeatPump(object):
    """ Object for heat pump model based on Jin (2002):
        H. Jin. Parameter estimation based models of water source heat pumps.
        PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.

    :param eva: Evaporator model.
    :param con: Condenser model.
    :param ref: Refrigerant model.
    :param fluCon: Fluid model for fluid on the condenser side.
    :param fluEva: Fluid model for fluid on the evaporator side.
    :param Q_nominal: Nominal heat pump capacity (W).
    :param P_nominal: Nominal heat pump power input (W).
    :param CoolingMode: Boolean, True if heat pump is in cooling mode.

    """
    def __init__(self, com, con, eva, ref, fluCon, fluEva,
                 Q_nominal, P_nominal, CoolingMode=False):
        self.eva = eva
        self.con = con
        self.com = com
        self.ref = ref
        self.fluCon = fluCon
        self.fluEva = fluEva
        self.Q_nominal = Q_nominal
        self.P_nominal = P_nominal
        self.CoolingMode = CoolingMode
        # Current entering fluid temperature on the evaporator side
        self._EWT_Source = 1e99
        # Current entering fluid temperature on the condenser side
        self._EWT_Load = 1e99
        # Current fluid flow rate temperature on the evaporator side
        self._flowSource = 1e99
        # Current fluid flow rate temperature on the condenser side
        self._flowLoad = 1e99

    def set_State(self, EWT_Source, EWT_Load, flowSource, flowLoad,
                  tol=1e-6, relax=0.7):
        """ Evaluates the current state of the heat pump.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).
        :param tol: Relative tolerance on the evaluation of the capacity and
                    heat pump power input (-).
        :param relax: Relaxation factor for the iteration procedure (-).

        """
        self._EWT_Source = EWT_Source
        self._EWT_Load = EWT_Load
        self._flowSource = flowSource
        self._flowLoad = flowLoad

        # Initial guesses and fluid temperatures
        if self.CoolingMode:
            QEva = - self.Q_nominal*0.5
            P = self.P_nominal*0.5
            QCon = P - QEva
            TEva_in = EWT_Load
            TCon_in = EWT_Source
            mEva_flow = flowLoad
            mCon_flow = flowSource
        else:
            QCon = self.Q_nominal*0.5
            P = self.P_nominal*0.5
            QEva = P - QCon
            TEva_in = EWT_Source
            TCon_in = EWT_Load
            mEva_flow = flowSource
            mCon_flow = flowLoad
        dQCon = 1e99
        dP = 1e99
        i = 0
        # Iterative evaluation of the heat pump state
        while (abs(dQCon/QCon) + abs(dP/P)) > tol and i < 1e3:
            # Evaluate rerigerant temperatures in the evaporator and condenser
            TEva = self.eva.get_RefrigerantTemperature(QEva, mEva_flow,
                                                       self.fluEva, TEva_in)
            TCon = self.con.get_RefrigerantTemperature(QCon, mCon_flow,
                                                       self.fluCon, TCon_in)
            TCon = max(TCon, TEva)
            # Evaluate refrigerant pressures in the evaporator and condenser
            pEva = self.ref.get_SaturatedVaporPressure(TEva)
            pCon = self.ref.get_SaturatedVaporPressure(TCon)
            # Evaluate specific enthalpies of the refrigerant a the outlet of
            # the evaporator and condenser
            hA = self.ref.get_SaturatedVaporEnthalpy(TEva)
            hB = self.ref.get_SaturatedLiquidEnthalpy(TCon)
            # Evaluate the suction and discharge pressures at the compressor
            pSuc = self.com.get_SuctionPressure(pEva)
            pDis = self.com.get_DischargePressure(pCon)
            # Evaluate the suction temperature
            TSuc = self.com.get_SuctionTemperature(TEva)
            # Evaluate the suction specific volume
            vSuc = self.ref.get_VaporSpecificVolume(pSuc, TSuc)
            # Evaluate the rerigerant mass flow rate
            m_flow = self.com.get_RefrigerantMassFlowRate(vSuc=vSuc,
                                                          ref=self.ref,
                                                          pDis=pDis,
                                                          pSuc=pSuc,
                                                          TSuc=TSuc)
            # Update the guess values
            dP = self.com.get_Power(vSuc=vSuc, ref=self.ref, pDis=pDis,
                                    pSuc=pSuc, TSuc=TSuc) - P
            dQEva = -m_flow * (hA - hB) - QEva
            QEva = QEva + relax*dQEva
            P += relax*dP
            dQCon = P - QEva - QCon
            QCon += relax*dQCon
        # Set the current state of the heat pump
        self._TEva = TEva
        self._TCon = TCon
        self._pEva = pEva
        self._pCon = pCon
        self._hA = hA
        self._hB = hB
        self._pSuc = pSuc
        self._pDis = pDis
        self._TSuc = TSuc
        self._vSuc = vSuc
        self._m_flow = m_flow
        self._QEva = QEva
        self._QCon = QCon
        self._P = P
        self._verify_State()
        return

    def get_Capacity(self, EWT_Source, EWT_Load, flowSource, flowLoad):
        """ Return heat pump capacity.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).

        :return: Heat pump capacity (W).

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> '%.2f' % heaPum.get_Capacity(298.8, 311.0, 0.71, 0.71)
           '24124.81'

        """
        if self.CoolingMode:
            capacity = -self.get_EvaporatorHeatTransferRate(EWT_Source,
                                                            EWT_Load,
                                                            flowSource,
                                                            flowLoad)
        else:
            capacity = self.get_CondenserHeatTransferRate(EWT_Source,
                                                          EWT_Load,
                                                          flowSource,
                                                          flowLoad)
        return capacity

    def get_SourceSideTransferRate(self, EWT_Source, EWT_Load, flowSource,
                                   flowLoad):
        """ Return heat pump source side heat transfer rate.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).

        :return: Heat pump source side heat transfer rate (W).

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> '%.2f' % heaPum.get_SourceSideTransferRate(298.8, 311.0, 0.71, 0.71)
           '19413.08'

        """
        if self.CoolingMode:
            HR = self.get_CondenserHeatTransferRate(EWT_Source, EWT_Load,
                                                    flowSource, flowLoad)
        else:
            HR = - self.get_EvaporatorHeatTransferRate(EWT_Source, EWT_Load,
                                                       flowSource, flowLoad)
        return HR

    def get_EvaporatorHeatTransferRate(self, EWT_Source, EWT_Load,
                                       flowSource, flowLoad):
        """ Evaluate evaporator heat transfer rate.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).

        :return: Evaporator heat transfer rate (W).

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> '%.2f' % heaPum.get_EvaporatorHeatTransferRate(298.8, 311.0, 0.71, 0.71)
           '-19413.08'

        """
        # Evaluate heat pump state if different from current state
        if not self._isCurrentState(EWT_Source, EWT_Load, flowSource,
                                    flowLoad):
            self.set_State(EWT_Source, EWT_Load, flowSource, flowLoad)
        return self._QEva

    def get_CondenserHeatTransferRate(self, EWT_Source, EWT_Load, flowSource,
                                      flowLoad):
        """ Evaluate condenser heat transfer rate.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).

        :return: condenser heat transfer rate (W).

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> '%.2f' % heaPum.get_CondenserHeatTransferRate(298.8, 311.0, 0.71, 0.71)
           '24124.81'

        """
        # Evaluate heat pump state if different from current state
        if not self._isCurrentState(EWT_Source, EWT_Load, flowSource,
                                    flowLoad):
            self.set_State(EWT_Source, EWT_Load, flowSource, flowLoad)
        return self._QCon

    def get_Power(self, EWT_Source, EWT_Load, flowSource, flowLoad):
        """ Evaluate heat pump power input.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).

        :return: Heat pump power input (W).

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> '%.2f' % heaPum.get_Power(298.8, 311.0, 0.71, 0.71)
           '4711.73'

        """
        # Evaluate heat pump state if different from current state
        if not self._isCurrentState(EWT_Source, EWT_Load, flowSource,
                                    flowLoad):
            self.set_State(EWT_Source, EWT_Load, flowSource, flowLoad)
        return self._P

    def set_ModelicaParameters(self, simulator):
        """ Set parameter values for simulation in dymola.

        :param simulator: Simulator object (BuildingsPy)

        :return: Simulator object (BuildingsPy)

        """
        # Set parameters for the compressor model
        simulator = self.com.set_ModelicaParameters(simulator)
        # Set parameters for the condenser model
        simulator = self.con.set_ModelicaParameters(simulator, 'Con')
        # Set parameters for the evaporator model
        simulator = self.eva.set_ModelicaParameters(simulator, 'Eva')
        # Redeclare packages for fluid and refrigerant
        fluConModel = self.fluCon.modelicaModelPath()
        fluEvaModel = self.fluEva.modelicaModelPath()
        refModel = self.ref.modelicaModelPath()
        simulator.addModelModifier('redeclare package Medium1 = '
                                   + fluConModel)
        simulator.addModelModifier('redeclare package Medium2 = '
                                   + fluEvaModel)
        simulator.addModelModifier('redeclare package ref = '
                                   + refModel)
        return simulator

    def initialGuessParameters(self, data):
        """ Initialize guess parameters for calibration of the heat pump model.

        :param data: Heat pump performance data.

        :return: A list of parameters to the compressor model, a list of tuples
                 of the bounds of the parameters (min, max) for the calibration
                 routine.

        """
        if self.CoolingMode:
            i = 0
        else:
            i = -1
        TSouGuess = data.EWT_Source[i]
        TLoaGuess = data.EWT_Load[i]
        QGuess = data.Capacity[i]*1e3
        PGuess = data.Power[i]*1e3
        # Evaluate guess parameters for each heat pump component based on
        # nominal capacity and power consumption
        parCom, bouCom = self.com.initialGuessParameters(QGuess,
                                                         PGuess,
                                                         TSouGuess,
                                                         TLoaGuess,
                                                         self.ref,
                                                         self.CoolingMode)
        parCon, bouCon = self.con.initialGuessParameters(QGuess, PGuess)
        parEva, bouEva = self.eva.initialGuessParameters(QGuess, PGuess)
        parameters = parCom + parCon + parEva
        bounds = bouCom + bouCon + bouEva
        return np.array(parameters), bounds

    def modelicaCalibrationModelPath(self):
        """ Returns the full path to the heat pump model for calibration in the
            Buildings library.

        :return: Full path to the compressor model in the Buildings library.

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> heaPum.modelicaCalibrationModelPath()
           'Buildings.Fluid.HeatPumps.Calibration.ScrollWaterToWater'

        """
        if self.com.modelicaModelPath() == "Buildings.Fluid.HeatPumps.Compressors.ReciprocatingCompressor":
            return "Buildings.Fluid.HeatPumps.Calibration.ReciprocatingWaterToWater"
        elif self.com.modelicaModelPath() == "Buildings.Fluid.HeatPumps.Compressors.ScrollCompressor":
            return "Buildings.Fluid.HeatPumps.Calibration.ScrollWaterToWater"

    def modelicaModelName(self):
        """ Returns the name of the heat pump model for calibration in the
            Buildings library.

        :return: Full path to the compressor model in the Buildings library.

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> heaPum.modelicaModelName()
           'ScrollWaterToWater'

        """
        if self.com.modelicaModelPath() == "Buildings.Fluid.HeatPumps.Compressors.ReciprocatingCompressor":
            return "ReciprocatingWaterToWater"
        elif self.com.modelicaModelPath() == "Buildings.Fluid.HeatPumps.Compressors.ScrollCompressor":
            return "ScrollWaterToWater"

    def modelicaModelPath(self):
        """ Returns the full path to the heat pump model in the Buildings
        library.

        :return: Full path to the compressor model in the Buildings library.

        Usage: Type
           >>> import compressors
           >>> import heatexchangers
           >>> import fluids
           >>> import refrigerants
           >>> com = compressors.ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> eva = heatexchangers.EvaporatorCondenser([21523])
           >>> con = heatexchangers.EvaporatorCondenser([2840.4])
           >>> flu = fluids.ConstantPropertyWater()
           >>> ref = refrigerants.R410A()
           >>> heaPum = SingleStageHeatPump(com, con, eva, ref, flu, flu, 19300.0, 4289.0)
           >>> heaPum.modelicaModelPath()
           'Buildings.Fluid.HeatPumps.ScrollWaterToWater'

        """
        if self.com.modelicaModelPath() == "Buildings.Fluid.HeatPumps.Compressors.ReciprocatingCompressor":
            return "Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater"
        elif self.com.modelicaModelPath() == "Buildings.Fluid.HeatPumps.Compressors.ScrollCompressor":
            return "Buildings.Fluid.HeatPumps.ScrollWaterToWater"

    def printParameters(self):
        """ Prints the value of the model parameters.

        """
        print('Compressor:\n'
              + '-----------')
        self.com.printParameters()
        print('Condenser:\n'
              + '-----------')
        self.con.printParameters()
        print('Evaporator:\n'
              + '-----------')
        self.eva.printParameters()
        return

    def reinitializeParameters(self, parameters):
        """ Reinitializes the heat pump using new parameters.

        :param parameters: Heat pump parameters.

        """
        # Replace current component parameters and reset heat pump state
        self._EWT_Source = 1e99
        self._EWT_Load = 1e99
        self._flowSource = 1e99
        self._flowLoad = 1e99
        NParCom = self.com.NPar
        NParCon = self.con.NPar
        NParEva = self.eva.NPar
        self.com.reinitializeParameters(parameters[0:NParCom])
        self.con.reinitializeParameters(parameters[NParCom:NParCom + NParCon])
        self.eva.reinitializeParameters(parameters[NParCom + NParCon:NParCom
                                                   + NParCon + NParEva])
        return

    def _isCurrentState(self, EWT_Source, EWT_Load, flowSource,
                        flowLoad, tol=1e-6):
        """ Check if the current state is the same as the requested state.

        :param EWT_Source: Entering water temperature on the source side (K).
        :param EWT_Load: Entering water temperature on the load side (K).
        :param flowSource: Fluid mass flow rate on the source side (kg/s).
        :param flowLoad: Fluid mass flow rate on the load side (kg/s).

        """
        isCurrentState = (abs((EWT_Source-self._EWT_Source)/self._EWT_Source) < tol and
                          abs((EWT_Load-self._EWT_Load)/self._EWT_Load) < tol and
                          abs((flowSource-self._flowSource)/self._flowSource) < tol and
                          abs((flowLoad-self._flowLoad)/self._flowLoad) < tol)
        return isCurrentState

    def _verify_State(self):
        """ Verify if the calculated state is a valid heat pump state.
        """
        if (self._TCon > self.ref.TCri or
                self._TEva < self.ref.T_min or
                self._m_flow < 0.0):

            self._QEva = 0.0
            self._QCon = 0.0
            self._P = -abs(self._P)*0.
        return
