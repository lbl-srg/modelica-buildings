class ConstantPropertyWater(object):
    """ Object for the evaluation of thermal properties of heat transfer fluid
        Water.
    """

    def __init__(self):
        # Density (kg/m3) of water at 20 C
        self._d = 998.207150468
        # Specific heat capacity at constant pressure (J/(kg.K)) of water
        # at 20 C
        self._cp = 4184.05092452
        # Specific volume (m3/kg) of water at 20 C
        self._v = 0.00100179606961

    def get_Density(self, **kwargs):
        """ Returns the density of water.

        :return: Density of water at 20 C (kg/m3)

        """
        return self._d

    def get_SpecificIsobaricHeatCapacity(self, **kwargs):
        """ Returns the specific isobaric heat capacity of water.

        :return: Specific isobaric heat capacity of water at 20 C (J/(kg.K))

        """
        return self._cp

    def get_SpecificVolume(self, **kwargs):
        """ Returns the specific volume of water.

        :return: Specific volume of water at 20 C (m3/kg)

        """
        return self._v

    def modelicaModelPath(self):
        """ Returns the full path to the water model in the Buildings library.

        :return: Full path to the water model in the Buildings library.

        .. Note:: The minimum temperature is set to -50 C to avoid the Modelica
                  model from failing.

        """
        return 'Modelica.Media.Water.ConstantPropertyLiquidWater(T_min=223.15)'
