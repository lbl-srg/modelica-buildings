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
	    - temperature (K to and from: degC, degF)
		- volume flow (m3/s to and from: *mg)
		- pressure (Pa to and from: *mg)
		- dimensionless (1 to and from %)

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
            #{
			# 'quantity' : 'Temperature',
			# 'modelica_quantity' : 'ThermodynamicTemperature',
			# 'unit' : 'degree fahrenheit',
			# 'unit_symbol' : 'degF',
			# 'direction' : 'From',
			# 'adder' : '-32 * (5/9) + 273.15',
			# 'multiplier' : '5/9'},
			# {
			# 'quantity' : 'Temperature',
		    # 'modelica_quantity' : 'ThermodynamicTemperature',
			# 'unit' : 'degree fahrenheit',
			# 'unit_symbol' : 'degF',
			# 'direction' : 'To',
			# 'adder' : '*mg_test',
			# 'multiplier' : '*mg_test'},
			#
			# {
			# 'quantity' : 'Temperature',
			# 'modelica_quantity' : 'ThermodynamicTemperature',
			# 'unit' : 'degree celsius',
			# 'unit_symbol' : 'degC',
			# 'direction' : 'From',
			# 'adder' : '*mg_test',
			# 'multiplier' : '*mg_test'},
			{
			'quantity' : 'Temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree celsius',
			'unit_symbol' : 'degC',
			'direction' : 'To',
			'adder' : '-273.15',
			'multiplier' : '1'},

			 # continue the list for temp, pres, volflow
			]

		si_unit_pardict = {
			'Temperature' :
				{'unit' : 'kelvin',
				 'unit_symbol' : 'K'},
			'Pressure' :
				{'unit' : 'pascal',
				 'unit_symbol' : 'Pa'},
            'Volume Flow' :
				{'unit' : 'cubic meters per second',
				 'unit_symbol' : 'm3/s'},
		    'Dimensionless' :
				{'unit' : '-',
				 'unit_symbol' : '1'},
			    }

		return conv_pardict_list, si_unit_pardict


	def write_unit_converters(self):
		"""Generates unit conversion modelica code for each
		converter.
		"""

		for x in self.par:

			if x['direction'] == 'From':
				to_unit_symbol = self.si[x['quantity']]['unit_symbol']
				to_unit = self.si[x['quantity']]['unit']
				from_unit_symbol = x['unit_symbol']
				from_unit = x['unit']
			else:
				to_unit_symbol = x['unit_symbol']
				to_unit = x['unit']
				from_unit_symbol = self.si[x['quantity']]['unit_symbol']
				from_unit = self.si[x['quantity']]['unit']
			if x['direction'] == 'To':
				from_unit_symbol = self.si[x['quantity']]['unit_symbol']
				from_unit = self.si[x['quantity']]['unit']
				to_unit_symbol = x['unit_symbol']
				to_unit = x['unit']
			else:
				from_unit_symbol = x['unit_symbol']
				from_unit = x['unit']
				to_unit_symbol = self.si[x['quantity']]['unit_symbol']
				to_unit = self.si[x['quantity']]['unit']


			# set filename to final mo filename (e.g. From_degF)
			converter_model_filename = \
				x['direction'] + '_' + to_unit_symbol + '.mos'
			# open
			file = open(os.path.join(\
				self.outpath, converter_model_filename), 'w')
			# write
			file.write(\
"block " + converter_model_filename + " \"Kelvin to degree Celsius temperature unit converter\"\n" \
"\n"\
"  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(\n" \
"    final unit = \"" + from_unit_symbol + "\",\n"\
"    final quantity = \""+x['modelica_quantity']+"\")\n"\
"    \"Temparature in " + from_unit + " [" + from_unit_symbol + "]\"\n"\
"    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),\n"\
"      iconTransformation(extent={{-140,-20},{-100,20}})));\n"\
"\n"\
"  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(\n"\
"    final unit = \"" + to_unit_symbol + "\",\n"\
"    final quantity = \""+x['modelica_quantity']+"\")\n"\
"    \"Temparature in " + to_unit + " [" + to_unit_symbol + "]\"\n"\
"    annotation (Placement(transformation(extent={{40,-10},{60,10}}),\n"\
"      iconTransformation(extent={{100,-10},{120,10}})));\n"\
"\n"\
"protected\n"\
"  parameter Real k = " + x['multiplier'] + " \"Multiplier\";\n"\
"  parameter Real p = " + x['adder'] + " \"Adder\";\n"\
"\n"\
"  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(\n"\
"    final p = p,\n"\
"    final k = k) \"Unit converter\"\n"\
"    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));\n"\
"\n"\
"equation\n"\
"  connect(u, addPar.u)\n"\
"    annotation (Line(points={{-60,0},{-12,0}}, color={0,0,127}));\n"\
"  connect(addPar.y, y)\n"\
"    annotation (Line(points={{11,0},{50,0}}, color={0,0,127}));\n"\
"  annotation (\n"\
"      defaultComponentName = \"" + converter_model_filename[:-4] + "\",\n"\
"    Icon(graphics={\n"\
"        Rectangle(\n"\
"          extent={{-100,-100},{100,100}},\n"\
"          lineColor={0,0,127},\n"\
"          fillColor={255,255,255},\n"\
"          fillPattern=FillPattern.Solid),\n"\
"        Line(points={{20,58}}, color={28,108,200}),\n"\
"        Text(\n"\
"          lineColor={0,0,255},\n"\
"          extent={{-150,110},{150,150}},\n"\
"          textString=\"%name\"),\n"\
"        Text(\n"\
"          extent={{-80,40},{0,0}},\n"\
"          lineColor={0,0,127},\n"\
"          textString=\"" + from_unit_symbol + "\"),\n"\
"        Text(\n"\
"          extent={{0,-40},{80,0}},\n"\
"          lineColor={0,0,127},\n"\
"          textString=\"" + to_unit_symbol + "\")}),\n"\
"        Documentation(info=\"<html>\n"\
"<p>\n"\
"Converts temperature given in " + from_unit + " [" + from_unit_symbol + "] to degree " + to_unit + " [" + to_unit_symbol + "].\n"\
"</p>\n"\
"</html>\", revisions=\"<html>\n"\
"<ul>\n"\
"<li>\n"\
"July 05, 2018, by Milica Grahovac:<br/>\n"\
"First implementation.\n"\
"</li>\n"\
"</ul>\n"\
"</html>\"));\n"\
"end " + converter_model_filename + ";\n"\
)

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
