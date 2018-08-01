

class UnitConverterModeler(object):
	'''Creates OBC unit converter models
	based on the dictionaries with conversion
	parameters. The parameters determine
	the quantities, units, and the conversion direction.

	The conversions included are:
		- non-SI unit --> SI unit
		- SI unit --> non-SI unit

	Quantities included are:
	    - temperature (degC)
		- volume flow (m3/s)
		- pressure (Pa)
		- precentage (1)
	'''

	def __init___(self):
		self.p, self.si = set_parameters()


	def set_parameters(self, outpath):
		'''Creats a list of dictionaries, where each of these
		dictionaries represents one unit converter.
		'''

		create_conversions_for = [
            {
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Fahrenheit',
			'unit_symbol' : 'degF',
			'direction' = 'From',
			'adder' = '-32 * (5/9) + 273.15',
			'multiplier' = '5/9'},
			{
			'quantity' : 'Temperature',
		    'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Fahrenheit',
			'unit_symbol' : 'degF',
			'direction' = 'To',
			'adder' = '',
			'multiplier' = ''},

			{
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Celsius',
			'unit_symbol' : 'degC',
			'direction' = 'From',
			'adder' = '',
			'multiplier' = ''},
			{
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Celsius',
			'unit_symbol' : 'degC',
			'direction' = 'To',
			'adder' = '',
			'multiplier' = ''},

			 # continue the list for temp, pres, volflow
			]

		si_units = {
			'Temperature' :
				{'unit' : 'Kelvin',
				 'unit_symbol' : 'K'}
			'Pressure' :
				{'unit' : 'Pascal',
				 'unit_symbol' : 'Pa'}
            'Volume Flow' :
				{'unit' : 'cubicMetersPerSecond',
				 'unit_symbol' : 'm3/s'}
			    }

		return conv_pardict_list, si_unit_pardict


	def write_unit_converters(self):
		"""Iterates through all unit converters and
		generates unit conversion modelica code for each.
		"""

		for x in self.p:
			# set filename 






# walk through the create_conversions_for list and create a block, a validation block and a mos script.
