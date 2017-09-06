from __future__ import division, print_function, absolute_import

import numpy as np


class R410A(object):
    """ Class for the evaluation of properties of refrigerant R410A.

        Properties are based on commercial refrigerant Dupont Suva 410A.
    """

    def __init__(self):
        self.TCri = 345.25          # Critical temperature (K)
        self.pCri = 4926.1e3        # Critical pressure (Pa)
        self.vCri = 0.00205         # Critical volume (m3/kg)
        self._k = 1.273             # Isentropic exponent (-)
        # Minimum temperature for property evaluation (K)
        self.T_min = 173.15

    def get_IsentropicExponent_vT(self, v, T):
        """ Evaluate the isentropic exponent.

        :param v: Specific volume of the refrigerant (m3/kg).
        :param T: Temperature of the refrigerant (K).

        :return: Isentropic exponent (-).

        Usage: Type
           >>> ref = R410A()
           >>> '%.4f' % ref.get_IsentropicExponent_vT(0.025, 289.64)
           '1.3862'

        """
        cp = self.get_SpecificIsobaricHeatCapacity_vT(v, T)
        cv = self.get_SpecificIsochoricHeatCapacity_vT(v, T)
        k = cp / cv
        return k

    def get_SpecificIsobaricHeatCapacity_vT(self, v, T):
        """ Evaluate the specific isobaric heat capacity.

        :param v: Specific volume of the refrigerant (m3/kg).
        :param T: Temperature of the refrigerant (K).

        :return: Specific isobaric heat capacity (J/kg-K).

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_SpecificIsobaricHeatCapacity_vT(0.025, 289.64)
           '1167.01'

        """
        R, A, B, C, b, k = self._martinHouCoefficients()
        cv = self.get_SpecificIsochoricHeatCapacity_vT(v, T)
        Tr = T / self.TCri

        dpdT = R / (v - b)
        dpdv = -R*T/(v - b)**2
        for i in range(len(A)):
            dpdT += (B[i] - k/self.TCri*C[i]*np.exp(-k*Tr)) / (v - b)**(i + 2)
            dpdv += -(float(i+2)*(A[i] + B[i]*T
                      + C[i]*np.exp(-k*Tr))/(v-b)**(i+3))
        cp = cv - T * dpdT**2 / dpdv
        return cp

    def get_SpecificIsochoricHeatCapacity_vT(self, v, T):
        """ Evaluate the specific isochoric heat capacity.

        :param v: Specific volume of the refrigerant (m3/kg).
        :param T: Temperature of the refrigerant (K).

        :return: Specific isochoric heat capacity (J/kg-K).

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_SpecificIsochoricHeatCapacity_vT(0.025, 289.64)
           '841.85'

        """
        R, A, B, C, b, k = self._martinHouCoefficients()
        cvo = self._get_IdealGasIsochoricHeatCapacity(T)
        Tr = T / self.TCri
        # Dimensionless value of cv
        intd2pdT2 = 0.
        for i in range(len(A)):
            intd2pdT2 += (k/self.TCri)**2 * C[i]*np.exp(-k*Tr) \
                / (float(i+1) * (v - b)**(i + 1))
        cv = cvo - T * intd2pdT2
        return cv

    def get_SaturatedLiquidPressure(self, TLiq):
        """ Evaluate the pressure of saturated liquid refrigerant.

        :param TLiq: Temperature of the saturated liquid refrigerant (K).

        :return: Pressure of saturated liquid refrigerant (Pa).

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_SaturatedLiquidPressure(305.25)
           '1989639.98'

        """
        a = [-1.4376, -6.8715, -0.53623, -3.82642, -4.06875, -1.2333]
        x0 = 0.2086902
        x = (1.0 - TLiq/self.TCri) - x0
        pLiq = self.pCri \
            * np.exp(self.TCri/TLiq * np.polynomial.polynomial.polyval(x, a))
        return pLiq

    def get_SaturatedVaporPressure(self, TVap):
        """ Evaluate the pressure of saturated refrigerant vapor.

        :param TLiq: Temperature of the saturated liquid refrigerant (K).

        :return: Pressure of saturated refrigerant vapor (Pa).

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_SaturatedVaporPressure(283.15)
           '1082792.93'

        """
        a = [-1.440004, -6.865265, -0.5354309, -3.749023, -3.521484, -7.75]
        x0 = 0.2086902
        x = (1.0 - TVap/self.TCri) - x0
        pVap = self.pCri \
            * np.exp(self.TCri/TVap * np.polynomial.polynomial.polyval(x, a))
        return pVap

    def get_SaturatedLiquidEnthalpy(self, TLiq):
        """ Evaluate the specific enthalpy of saturated liquid refrigerant.

        :param TLiq: Temperature of the saturated liquid refrigerant (K).

        :return: Specific enthalpy of saturated liquid refrigerant (J/kg).

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_SaturatedLiquidEnthalpy(305.25)
           '252787.45'

        """
        a = [221.1749, -514.9668, -631.625, -262.2749, 1052.0, 1596.0]
        x0 = 0.5541498
        x = (1.0 - TLiq/self.TCri)**(1.0/3.0) - x0
        hLiq = 1e3 * np.polynomial.polynomial.polyval(x, a)
        return hLiq

    def get_SaturatedVaporEnthalpy(self, TVap):
        """ Evaluate the specific enthalpy of saturated liquid refrigerant.

        :param TLiq: Temperature of the saturated liquid refrigerant (K).

        :return: Specific enthalpy of saturated liquid refrigerant (J/kg).

        .. note:: Correlated properties from the thermodynamic properties of
                  DuPont Suva R410A. An expression similar to the saturated
                  liquid enthalpy was used.

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_SaturatedVaporEnthalpy(283.15)
           '425094.18'

        """
        a = [406.0598, -34.78156, 262.8079, 223.8549, -1162.627, 570.6635]
        x0 = 0.0
        x = (1.0 - TVap/self.TCri)**(1.0/3.0) - x0
        hVap = 1e3 * np.polynomial.polynomial.polyval(x, a)
        return hVap

    def get_VaporPressure(self, TVap, vVap):
        """ Evaluate the pressure of refrigerant vapor.

        :param TVap: Temperature of refrigerant vapor (K).
        :param vVap: Specific volume of refrigerant vapor (m3/kg).

        :return: Pressure of refrigerant vapor (Pa).

        The pressure is calculated fromthe Martin-Hou equation of state for
        refrigerant  R410A.

        Usage: Type
           >>> ref = R410A()
           >>> '%.2f' % ref.get_VaporPressure(289.64, 0.025)
           '1083546.30'

        """
        R, A, B, C, b, k = self._martinHouCoefficients()

        pVap = R*TVap/(vVap - b)
        for i in range(len(A)):
            pVap = pVap + (A[i] + B[i]*TVap
                           + C[i]*np.exp(-k*TVap/self.TCri)) \
                           / (vVap - b)**(i + 2.0)
        return pVap

    def get_VaporSpecificVolume(self, p, T, tol=1e-6):
        """ Evaluate the Specific of refrigerant vapor.

        :param p: Pressure of refrigerant vapor (Pa).
        :param T: Temperature of refrigerant vapor (K).

        :return: Specific volume of refrigerant vapor (m3/kg).

        Uses the Martin-Hou equation of state to determine specific volume.

        Usage: Type
           >>> ref = R410A()
           >>> '%.8f' % ref.get_VaporSpecificVolume(1083546.3, 289.64)
           '0.02500001'

        """
        R = 114.55
        b = 4.355134e-4
        # Initial guess from the first term in the equation of state
        v = R*T/p + b
        dv = 1e99
        i = 0
        # Iterative evaluation of the specific volume
        while abs(dv)/v > tol and i < 1e3:
            i += 1
            # Error on pressure
            dp = p - self.get_VaporPressure(T, v)
            # Specific volume adjustment
            dv = dp / self._dpdv(T, v)
            v = v + dv
        return v

    def modelicaModelPath(self):
        """ Returns the full path to the refrigerant package in the Buildings
            library.

        :return: Full path to the refrigerant package in the Buildings library.

        Usage: Type
           >>> ref = R410A()
           >>> ref.modelicaModelPath()
           'Buildings.Media.Refrigerants.R410A'

        """
        return 'Buildings.Media.Refrigerants.R410A'

    def _get_IdealGasIsobaricHeatCapacity(self, T):
        """ Evaluate the ideal gas specific isobaric heat capacity.

        :param T: Temperature of refrigerant vapor (K).

        :return: Ideal gas specific isobaric heat capacity (J/kg-K).

        """
        a = [2.676087e-1, 2.115353e-3, -9.848184e-7, 6.493781e-11]
        cpo = 1e3*np.polynomial.polynomial.polyval(T, a)
        return cpo

    def _get_IdealGasIsochoricHeatCapacity(self, T):
        """ Evaluate the ideal gas specific isochoric heat capacity.

        :param T: Temperature of refrigerant vapor (K).

        :return: Ideal gas specific isochoric heat capacity (J/kg-K).

        """
        R = 114.55
        cpo = self._get_IdealGasIsobaricHeatCapacity(T)
        cvo = cpo - R
        return cvo

    def _dpdv(self, TVap, vVap):
        """ Derivative for specific volume in the Martin-Hou equation of state.

        :param TVap: Temperature of refrigerant vapor (K).
        :param vVap: Specific volume of refrigerant vapor (m3/kg).

        :return: Derivative of pressure with respect to specific volume
                 (Pa-kg/m3).

        """
        R, A, B, C, b, k = self._martinHouCoefficients()

        dpdv = -R*TVap/(vVap - b)**2.0
        for i in range(len(A)):
            dpdv = dpdv + (-i)*(A[i] + B[i]*TVap
                                + C[i]*np.exp(-k*TVap/self.TCri)) \
                                / (vVap - b)**(i + 3.0)
        return dpdv

    def _martinHouCoefficients(self):
        """ Return the coefficients to the Martin-Hou equation of state.

        :return: Coefficients to the Martin-Hou equation of state.

        """
        R = 114.55
        A = [-1.721781e2, 2.381558e-1, -4.329207e-4, -6.241072e-7]
        B = [1.646288e-1, -1.462803e-5, 0, 1.380469e-9]
        C = [-6.293665e3, 1.532461e1, 0, 1.604125e-4]
        b = 4.355134e-4
        k = 5.75
        return R, A, B, C, b, k
