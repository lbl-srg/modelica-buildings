from __future__ import division, print_function, absolute_import

import numpy as np


class EvaporatorCondenser(object):
    """ Object for heat exchanger based on epsilon-NTU method for a heat
        transfer fluid exchanging heat with refrigerant experiencing constant
        temperature phase change.

        :param UA: Heat transfer coefficient of the evaporator or
                   condenser (W/K).
    """

    def __init__(self, parameters):
        self.UA = parameters[0]
        self.NPar = 1
        return

    def get_RefrigerantTemperature(self, Q_flow, m_flow, flu, T_in):
        """ Evaluate the refrigerant temperature.

        :param Q_flow: Heat transfer rate to the fluid stream (W).
        :param m_flow: Fluid mass flow rate (kg/s).
        :param flu: Fluid model.
        :param T_in: Inlet fluid temperature (K).

        :return: Refrigerant temperature (K).

        Usage: Type
           >>> import fluids
           >>> flu = fluids.ConstantPropertyWater()
           >>> eva = EvaporatorCondenser([21523])
           >>> '%.2f' % eva.get_RefrigerantTemperature(19300, 0.71, flu, 298.75)
           '305.25'

        """
        # Evaluate evaporating/condesing temeprature of the refrigerant
        cp = flu.get_SpecificIsobaricHeatCapacity(T=T_in)
        # Heat exchanger effectiveness
        eps = self._heatExchangerEffectiveness(m_flow, cp)
        dT = Q_flow / (eps * m_flow * cp)
        TRef = T_in + dT
        return TRef

    def set_ModelicaParameters(self, simulator, suffix=''):
        """ Set parameter values for simulation in dymola.

        :param simulator: Simulator object (BuildinsPy)
        :param suffix: String to add at the end of parameter names.

        :return: Simulator object (BuildinsPy)

        """
        parameters = {'UA'+suffix: self.UA}
        simulator.addParameters(parameters)
        return simulator

    def initialGuessParameters(self, Q_nominal, P_nominal):
        """ Initialize guess parameters for calibration of the heat pump model.

        :param Q_nominal: Nominal heat pump capacity (W).
        :param P_nominal: Nominal power input (W).

        :return: A list of parameters to the compressor model, a list of tuples
                 of the bounds of the parameters (min, max) for the calibration
                 routine.

        """
        # Initialize guess parameters for the evaporator/condenser
        # Temperature difference between EWT and refrigerant temperature
        dT = 5.0
        UA = Q_nominal / dT
        return [UA], [(0., None)]

    def modelicaModelPath(self):
        """ Returns the full path to the EvaporatorCondenser model in the
            Buildings library.

        :return: Full path to the compressor model in the Buildings library.

        Usage: Type
           >>> eva = EvaporatorCondenser([21523])
           >>> eva.modelicaModelPath()
           'Buildings.Fluid.HeatExchangers.EvaporatorCondenser'

        """
        return 'Buildings.Fluid.HeatExchangers.EvaporatorCondenser'

    def printParameters(self):
        """ Prints the value of the model parameters.

        """
        print('Thermal conductance of the heat exchanger : '
              + str(self.UA) + ' W/K\n')
        return

    def reinitializeParameters(self, parameters):
        """ Reinitializes the evaporator or condenser using new parameters.

        :param UA: Heat transfer coefficient (W/K).

        """
        self.UA = parameters[0]
        return

    def _heatExchangerEffectiveness(self, m_flow, cp):
        """ Evaluate the heat exchanger effectiveness.

        :param m_flow: Fluid mass flow rate (kg/s).
        :param cp: Fluid isobaric heat capacity (J/(kgK)).

        :return: Heat exchanger effectiveness (-).

        """
        # Number of transfer units
        NTU = self.UA / (m_flow * cp)
        # Heat exchanger effectiveness
        eps = 1.0 - np.exp(-NTU)
        return eps
