import unittest
import os

from unit_converters import UnitConverterModeler

class UnitConverterModelerTests(unittest.TestCase):
    """Tests unit converter code generation.
    """

    @classmethod
    def setUp(self):
        """Sets up the output location to current path.
        """
        self.conv = UnitConverterModeler()


    def test_write_unit_converters(self):
        """Tests if the unit converters get written.
        """
        self.conv.write_unit_converters()


    def test_write_unit_converter_validators(self):
        """Tests if the unit converters get written.
        """
        self.conv.write_unit_converter_validators()


    def test_write_mos_validation_scripts(self):
        """
        """
        self.conv.write_mos_validation_scripts()
