import os
from pdb import set_trace as bp

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

	Parameters
	----------
    outpath : str
        Path to store unit converter models (*.mo files)
	'''

	def __init__(self, outpath = ''):

		self.par, self.si = self.set_parameters()
		self.outpath = outpath


	def set_parameters(self):
		'''Creats a list of dictionaries, where each of these
		dictionaries represents one unit converter.
		'''
		conv_pardict_list = [
            {
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Fahrenheit',
			'unit_symbol' : 'degF',
			'direction' : 'From',
			'adder' : '-32 * (5/9) + 273.15',
			'multiplier' : '5/9'},
			{
			'quantity' : 'Temperature',
		    'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Fahrenheit',
			'unit_symbol' : 'degF',
			'direction' : 'To',
			'adder' : '',
			'multiplier' : ''},

			{
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Celsius',
			'unit_symbol' : 'degC',
			'direction' : 'From',
			'adder' : '',
			'multiplier' : ''},
			{
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'Celsius',
			'unit_symbol' : 'degC',
			'direction' : 'To',
			'adder' : '',
			'multiplier' : ''},

			 # continue the list for temp, pres, volflow
			]

		si_unit_pardict = {
			'Temperature' :
				{'unit' : 'Kelvin',
				 'unit_symbol' : 'K'},
			'Pressure' :
				{'unit' : 'Pascal',
				 'unit_symbol' : 'Pa'},
            'Volume Flow' :
				{'unit' : 'cubicMetersPerSecond',
				 'unit_symbol' : 'm3/s'}
			    }

		return conv_pardict_list, si_unit_pardict


	def write_unit_converters(self):
		"""Generates unit conversion modelica code for each
		converter.
		"""

		for x in self.par:
			# set filename to final mo filename (e.g. From_degF)
			if x['direction'] == 'To':
				unit_symbol = self.si[x['quantity']]['unit_symbol']
			else:
				unit_symbol = x['unit_symbol']

			converter_model_filename = \
				x['direction'] + '_' + unit_symbol + '.mos'
			# open
			file = open(os.path.join(\
				self.outpath, converter_model_filename), 'w')
			# write
			file.write()

		pass



	def write_unit_converter_validators(self):
		"""Generates modelica code for unit conversion validation models
		"""

		validation_foldername = 'Validation'
		for x in self.par:
			# set file, open and write
			pass
		pass






# walk through the create_conversions_for list and create a block, a validation block and a mos script.
