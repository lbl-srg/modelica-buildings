from __future__ import division, print_function, absolute_import


class ReciprocatingCompressor(object):
    """ Object for reciprocating compressor model based on Jin (2002):
        H. Jin. Parameter estimation based models of water source heat pumps.
        PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.

        :param pisDis: Piston displacement (m3/s).
        :param cleFac: Clearance factor (-).
        :param etaEle: Electro-mechanical efficiency (-).
        :param PLos: Constant part of the power losses (W).
        :param pDro: Pressure drop at compressor suction and discharge (Pa).
        :param dTSup: Degree of superheating (K).
    """

    def __init__(self, parameters):
        self.pisDis = parameters[0]
        self.cleFac = parameters[1]
        self.etaEle = parameters[2]
        self.PLos = parameters[3]
        self.pDro = parameters[4]
        self.dTSup = parameters[5]
        self.NPar = 6
        return

    def get_SuctionTemperature(self, TEva):
        """ Evaluate the suction temperature.

        :param TEva: Evaporating temperature (K).

        :return: Suction temperature (K).

        Usage: Type
           >>> com = ReciprocatingCompressor([0.00162, 0.069, 0.696, 100.0, 99.29e3, 9.82])
           >>> '%.2f' % com.get_SuctionTemperature(283.15)
           '292.97'

        """
        # Apply superheating to evaporating temperature
        TSuc = TEva + self.dTSup
        return TSuc

    def get_SuctionPressure(self, pEva):
        """ Evaluate the suction pressure.

        :param pEva: Evaporating pressure (Pa).

        :return: Suction pressure (Pa).

        Usage: Type
           >>> com = ReciprocatingCompressor([0.00162, 0.069, 0.696, 100.0, 99.29e3, 9.82])
           >>> '%.1f' % com.get_SuctionPressure(1.083e6)
           '983710.0'

        """
        # Apply pressure drop at compressor suction
        pSuc = pEva - self.pDro
        return pSuc

    def get_DischargePressure(self, pCon):
        """Evaluate the discharge pressure (Pa).

        :param pCon: Condensing pressure (Pa).

        :return: Discharge pressure (Pa).

        Usage: Type
           >>> com = ReciprocatingCompressor([0.00162, 0.069, 0.696, 100.0, 99.29e3, 9.82])
           >>> '%.1f' % com.get_DischargePressure(1.879e6)
           '1978290.0'

        """
        # Apply pressure drop at compressor discharge
        pDis = pCon + self.pDro
        return pDis

    def get_RefrigerantMassFlowRate(self, vSuc, ref, pDis, pSuc, TSuc,
                                    **kargs):
        """Evaluate the refrigerant mass flow rate.

        :param vSuv: Suction specific volume (m3/kg).
        :param ref: Refrigerant model.
        :param pDis: Discharge pressure (Pa).
        :param pSuc: Suction pressure (Pa).
        :param TSuc: Suction temperature (K).

        :return: Refrigerant mass flow rate (kg/s).

        Usage: Type
           >>> import refrigerants
           >>> ref = refrigerants.R410A()
           >>> com = ReciprocatingCompressor([0.00162, 0.069, 0.696, 100.0, 99.29e3, 9.82])
           >>> '%.8f' % com.get_RefrigerantMassFlowRate(0.0288, ref, 1978290.0, 983710.0, 292.97)
           '0.05358166'

        """
        # Evaluate refrigerant mass flow rate
        k = ref.get_IsentropicExponent_vT(v=vSuc, T=TSuc)
        PR = max(0.0, pDis/pSuc)
        m_flow = self.pisDis/vSuc * (1.0 + self.cleFac
                                     - self.cleFac * (PR)**(1.0/k))
        return m_flow

    def get_Power(self, vSuc, ref, pDis, pSuc, TSuc, **kargs):
        """ Evaluate the power input to the compressor.

        :param vSuv: Suction specific volume (m3/kg).
        :param ref: Refrigerant model.
        :param pDis: Discharge pressure (Pa).
        :param pSuc: Suction pressure (Pa).
        :param TSuc: Suction temperature (K).

        :return: Power input to the compressor (W).

        Usage: Type
           >>> import refrigerants
           >>> ref = refrigerants.R410A()
           >>> com = ReciprocatingCompressor([0.00162, 0.069, 0.696, 100.0, 99.29e3, 9.82])
           >>> '%.2f' % com.get_Power(0.0288, ref, 1978290.0, 983710.0, 292.97)
           '1765.63'

        """
        # Evaluate compressor power consumption
        k = ref.get_IsentropicExponent_vT(v=vSuc, T=TSuc)
        PR = max(0.0, pDis/pSuc)
        m_flow = self.get_RefrigerantMassFlowRate(vSuc=vSuc, ref=ref,
                                                  pDis=pDis, pSuc=pSuc,
                                                  TSuc=TSuc)
        PThe = k/(k - 1.0) * m_flow * pSuc * vSuc * ((PR)**((k - 1.0)/k) - 1.0)
        P = PThe / self.etaEle + self.PLos
        return P

    def initialGuessParameters(self, Q_nominal, P_nominal, TSou_nominal,
                               TLoa_nominal, ref, CoolingMode):
        """ Initialize guess parameters for calibration of the heat pump model.

        :param Q_nominal: Nominal heat pump capacity (W).
        :param P_nominal: Nominal power input (W).
        :param TSou_nominal: Source-side water temperature at
                             nominal conditions (K).
        :param TLoa_nominal: Load-side water temperature at
                             nominal conditions (K).
        :param ref: Refrigerant model.
        :param CoolingMode: Boolean, True if heat pump is in cooling mode.

        :return: A list of parameters to the compressor model, a list of tuples
                 of the bounds of the parameters (min, max) for the calibration
                 routine.

        """
        # Initialize guess parameters for the reciprocating compressor
        # Temperature difference between EWT and evaporating temperature
        dTEva = 5.0
        # Temperature difference between EWT and condensing temperature
        dTCon = 5.0
        if CoolingMode:
            TEva = TLoa_nominal - dTEva
            TCon = TSou_nominal + dTCon
            QEva = - Q_nominal
        else:
            TEva = TSou_nominal - dTEva
            TCon = TLoa_nominal + dTCon
            QEva = P_nominal - Q_nominal
        pEva = ref.get_SaturatedVaporPressure(TEva)
        pCon = ref.get_SaturatedVaporPressure(TCon)
        hA = ref.get_SaturatedVaporEnthalpy(TEva)
        hB = ref.get_SaturatedLiquidEnthalpy(TEva)

        cleFac = 0.05
        etaEle = 0.8
        PLos = 0.05 * P_nominal
        pDro = 100.0e3
        dTSup = 8.0

        pDis = pCon + pDro
        pSuc = pEva - pDro
        TSuc = TEva + dTSup
        vSuc = ref.get_VaporSpecificVolume(pSuc, TSuc)
        kSuc = ref.get_IsentropicExponent_vT(vSuc, TSuc)
        m_flow = -QEva / (hA - hB)

        pisDis = m_flow * vSuc / (1.0 + cleFac
                                  - cleFac * (pDis/pSuc)**(1.0/kSuc))

        pisDis = 1.5e-7 * Q_nominal
        cleFac = 0.05
        etaEle = 0.8
        PLos = 0.1 * P_nominal
        pDro = 100e3
        dTSup = 5

        bounds = [(0., None), (0., 1.), (0., 1.),
                  (0., 0.2*P_nominal), (0., None), (0., 10.)]
        return [pisDis, cleFac, etaEle, PLos, pDro, dTSup], bounds

    def modelicaModelPath(self):
        """ Returns the full path to the compressor model in the Buildings
            library.

        :return: Full path to the compressor model in the Buildings library.

        Usage: Type
           >>> com = ReciprocatingCompressor([0.00162, 0.069, 0.696, 100.0, 99.29e3, 9.82])
           >>> com.modelicaModelPath()
           'Buildings.Fluid.HeatPumps.Compressors.ReciprocatingCompressor'

        """
        return 'Buildings.Fluid.HeatPumps.Compressors.ReciprocatingCompressor'

    def printParameters(self):
        """ Prints the value of the model parameters.

        """
        print('Piston displacement : ' + str(self.pisDis) + ' m3/s')
        print('Clearance factor : ' + str(self.cleFac) + ' ')
        print('Electro-mechanical efficiency : ' + str(self.etaEle) + ' ')
        print('Constant part of power losses : ' + str(self.PLos) + ' W')
        print('Suction and discharge pressure drop : ' + str(self.pDro) + ' Pa')
        print('Amplitude of superheating : ' + str(self.dTSup) + ' K\n')
        return

    def reinitializeParameters(self, parameters):
        """ Reinitializes the compressor using new parameters.

        :param pisDis: Piston displacement (m3/s).
        :param cleFac: Clearance factor (-).
        :param etaEle: Electro-mechanical efficiency (-).
        :param PLos: Constant part of the power losses (W).
        :param pDro: Pressure drop at compressor suction and discharge (Pa).
        :param dTSup: Degree of superheating (K).

        """
        self.pisDis = parameters[0]
        self.cleFac = parameters[1]
        self.etaEle = parameters[2]
        self.PLos = parameters[3]
        self.pDro = parameters[4]
        self.dTSup = parameters[5]
        return


class ScrollCompressor(object):
    """ Object for scroll compressor model based on Jin (2002):
        H. Jin. Parameter estimation based models of water source heat pumps.
        PhD Thesis. Oklahoma State University. Stillwater, Oklahoma, USA. 2012.

        :param volRat: Volume ratio (-).
        :param v_flow: Nominal Volume flow rate (m3/s).
        :param leaCoe: LEakage coefficient (kg/s).
        :param etaEle: Electro-mechanical efficiency (-).
        :param PLos: Constant part of the power losses (W).
        :param dTSup: Degree of superheating (K).

    """

    def __init__(self, parameters):
        self.volRat = parameters[0]
        self.v_flow = parameters[1]
        self.leaCoe = parameters[2]
        self.etaEle = parameters[3]
        self.PLos = parameters[4]
        self.dTSup = parameters[5]
        self.NPar = 6
        return

    def get_SuctionTemperature(self, TEva):
        """ Evaluate the suction temperature.

        :param TEva: Evaporating temperature (K).

        :return: Suction temperature (K).

        Usage: Type
           >>> com = ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> '%.2f' % com.get_SuctionTemperature(283.15)
           '289.64'

        """
        # Apply superheating to evaporating temperature
        TSuc = TEva + self.dTSup
        return TSuc

    def get_SuctionPressure(self, pEva):
        """ Evaluate the suction pressure.

        :param pEva: Evaporating pressure (Pa).

        :return: Suction pressure (Pa).

        Usage: Type
           >>> com = ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> '%.1f' % com.get_SuctionPressure(1.083e6)
           '1083000.0'

        """
        # No pressure drop at compressor suction
        pSuc = pEva
        return pSuc

    def get_DischargePressure(self, pCon):
        """Evaluate the discharge pressure (Pa).

        :param pCon: Condensing pressure (Pa).

        :return: Discharge pressure (Pa).

        Usage: Type
           >>> com = ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> '%.1f' % com.get_DischargePressure(1.879e6)
           '1879000.0'

        """
        # No pressure drop at compressor discharge
        pDis = pCon
        return pDis

    def get_RefrigerantMassFlowRate(self, vSuc, pDis, pSuc, **kargs):
        """Evaluate the refrigerant mass flow rate.

        :param vSuv: Suction specific volume (m3/kg).
        :param pDis: Discharge pressure (Pa).
        :param pSuc: Suction pressure (Pa).
        :param TSuc: Suction temperature (K).

        :return: Refrigerant mass flow rate (kg/s).

        Usage: Type
           >>> com = ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> '%.6f' % com.get_RefrigerantMassFlowRate(0.025, 1.879e6, 1.083e6)
           '0.107687'

        """
        # Evaluate refrigerant mass flwo rate
        m_leak = self._leakageMassFlowRate(pDis, pSuc)
        m_flow = self.v_flow/vSuc - m_leak
        return m_flow

    def get_Power(self, vSuc, ref, pDis, pSuc, TSuc):
        """ Evaluate the power input to the compressor.

        :param vSuv: Suction specific volume (m3/kg).
        :param ref: Refrigerant model.
        :param pDis: Discharge pressure (Pa).
        :param pSuc: Suction pressure (Pa).
        :param TSuc: Suction temperature (K).

        :return: Power input to the compressor (W).

        Usage: Type
           >>> import refrigerants
           >>> ref = refrigerants.R410A()
           >>> com = ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> '%.2f' % com.get_Power(0.025, ref, 1.879e6, 1.083e6, 289.64)
           '2940.26'

        """
        # Evaluate compressor power consumption
        k = ref.get_IsentropicExponent_vT(v=vSuc, T=TSuc)
        PR = max(0.0, pDis/pSuc)    # External pressure ratio
        PRInt = self.volRat**k      # Built-in pressure ratio
        PThe = k/(k - 1.0) * pSuc * self.v_flow \
            * (((k - 1.0)/k) * PR/self.volRat
               + 1.0/k * PRInt**((k - 1.0)/k) - 1.0)
        P = PThe / self.etaEle + self.PLos
        return P

    def set_ModelicaParameters(self, simulator, suffix=''):
        """ Set parameter values for simulation in dymola.

        :param simulator: Simulator object (BuildinsPy)
        :param suffix: String to add at the end of parameter names.

        :return: Simulator object (BuildingsPy)

        """
        parameters = {'volRat'+suffix: self.volRat,
                      'V_flow_nominal'+suffix: self.v_flow,
                      'leaCoe'+suffix: self.leaCoe,
                      'etaEle'+suffix: self.etaEle,
                      'PLos'+suffix: self.PLos,
                      'dTSup'+suffix: self.dTSup}
        simulator.addParameters(parameters)
        return simulator

    def initialGuessParameters(self, Q_nominal, P_nominal, TSou_nominal,
                               TLoa_nominal, ref, CoolingMode):
        """ Initialize guess parameters for calibration of the heat pump model.

        :param Q_nominal: Nominal heat pump capacity (W).
        :param P_nominal: Nominal power input (W).
        :param TSou_nominal: Source-side water temperature at
                             nominal conditions (K).
        :param TLoa_nominal: Load-side water temperature at
                             nominal conditions (K).
        :param ref: Refrigerant model.
        :param CoolingMode: Boolean, True if heat pump is in cooling mode.

        :return: A list of parameters to the compressor model, a list of tuples
                 of the bounds of the parameters (min, max) for the calibration
                 routine.

        """
        # Initialize guess parameters for the scroll compressor
        dTEva = 5.0    # Temp. difference between EWT and evaporating temp.
        dTCon = 5.0    # Temp. difference between EWT and condensing temp.
        dTSup = 4.0
        if CoolingMode:
            TEva = TLoa_nominal - dTEva
            TCon = TSou_nominal + dTCon
            QEva = -Q_nominal
        else:
            TEva = TSou_nominal - dTEva
            TCon = TLoa_nominal + dTCon
            QEva = (P_nominal - Q_nominal)
        pEva = ref.get_SaturatedVaporPressure(TEva)
        pCon = ref.get_SaturatedVaporPressure(TCon)
        hA = ref.get_SaturatedVaporEnthalpy(TEva)
        hB = ref.get_SaturatedLiquidEnthalpy(TEva)

        TSuc = TEva + dTSup
        vSuc = ref.get_VaporSpecificVolume(pEva, TSuc)
        kSuc = ref.get_IsentropicExponent_vT(vSuc, TSuc)
        volRat = (pCon/pEva)**(1.0/kSuc)

        m_flow = -QEva / (hA - hB)
        m_leak = 0.01*m_flow
        v_flow = (m_flow + m_leak) * vSuc

        PThe = kSuc/(kSuc - 1.0) * pEva * v_flow \
            * ((pCon/pEva)**((kSuc - 1.0)/kSuc) - 1.0)

        etaEle = 0.95
        PLos = max(etaEle * P_nominal - PThe, 0.0)
        leaCoe = m_leak / (pCon/pEva)

#        bounds = [(1., None), (0., None), (0., 1.),
#                  (0., 1.), (0., None), (0., None)]
        bounds = [(1.5, 3.5), (0., None), (1.0e-4, 1.),
                  (0., 1.), (0., 0.25*P_nominal), (0., 10.)]
        return [volRat, v_flow, leaCoe, etaEle, PLos, dTSup], bounds

    def modelicaModelPath(self):
        """ Returns the full path to the compressor model in the Buildings
            library.

        :return: Full path to the compressor model in the Buildings library.

        Usage: Type
           >>> com = ScrollCompressor([2.362, 0.00287, 0.0041, 0.922, 398.7, 6.49])
           >>> com.modelicaModelPath()
           'Buildings.Fluid.HeatPumps.Compressors.ScrollCompressor'

        """
        return 'Buildings.Fluid.HeatPumps.Compressors.ScrollCompressor'

    def printParameters(self):
        """ Prints the value of the model parameters.

        """
        print('Volume ratio : ' + str(self.volRat) + ' ')
        print('Volume flow rate : ' + str(self.v_flow) + ' m3/s')
        print('Leakage coefficient : ' + str(self.leaCoe) + ' kg/s')
        print('Electro-mechanical efficiency : ' + str(self.etaEle) + ' ')
        print('Constant part of power losses : ' + str(self.PLos) + ' W')
        print('Amplitude of superheating : ' + str(self.dTSup) + ' K\n')
        return

    def reinitializeParameters(self, parameters):
        """ Reinitializes the compressor using new parameters.

        :param volRat: Volume ratio (-).
        :param v_flow: Nominal Volume flow rate (m3/s).
        :param leaCoe: LEakage coefficient (kg/s).
        :param etaEle: Electro-mechanical efficiency (-).
        :param PLos: Constant part of the power losses (W).
        :param dTSup: Degree of superheating (K).

        """
        self.volRat = parameters[0]
        self.v_flow = parameters[1]
        self.leaCoe = parameters[2]
        self.etaEle = parameters[3]
        self.PLos = parameters[4]
        self.dTSup = parameters[5]
        return

    def _leakageMassFlowRate(self, pDis, pSuc):
        """ Evaluate the leakage mass flow rate.

        :param pDis: Discharge pressure (Pa).
        :param pSuc: Suction pressure (Pa).

        :return: Leakage mass flow rate (kg/s).

        """
        m_leak = self.leaCoe*pDis/pSuc
        return m_leak
