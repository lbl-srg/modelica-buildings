import os
from pdb import set_trace as bp

import logging
logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

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

	def __init__(self,\
	             path_to_package = '',\
				 path_to_validation_scripts = 'MosPath',
				 package_name = 'UnitConverters',\
				 ):

		self.par, self.si = self.set_parameters()

		# path to unit converter package folder
		self.outpath = os.path.join(path_to_package, package_name)
		# path to unit converter package validation scripts folder
		self.validation_scripts_outpath = \
			os.path.join(path_to_validation_scripts, package_name)

		self.package_name = package_name



	def set_parameters(self):
		'''Creats a list of dictionaries, where each of these
		dictionaries represents one unit converter.
		'''
		conv_pardict_list = [
            {
			'quantity' : 'temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree fahrenheit',
			'unit_symbol' : 'degF',
			'direction' : 'From',
			'adder' : '-32 * (5/9) + 273.15',
			'multiplier' : '5/9'},
			'validation_input' : [, ], # tests are using two points to chech the conversion
			'validation_output' : [, ]},
			{
			'quantity' : 'temperature',
		    'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree fahrenheit',
			'unit_symbol' : 'degF',
			'direction' : 'To',
			'adder' : '*mg_test',
			'multiplier' : '*mg_test'},

			{
			'quantity' : 'temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree celsius',
			'unit_symbol' : 'degC',
			'direction' : 'From',
			'adder' : '*mg_test',
			'multiplier' : '*mg_test'},
			{
			'quantity' : 'temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree celsius',
			'unit_symbol' : 'degC',
			'direction' : 'To',
			'adder' : 273.15,
			'multiplier' : 1.,
			'validation_input' : [273.15, 373.15],
			'validation_output' : [0, 100]},

			 # continue the list for temp, pres, volflow
			]

		si_unit_pardict = {
			'temperature' :
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

	def extract_unit_strings(self, x):
		"""Depending on the conversion direction it extracts
		the unit names and symbols.

		Parameters
		----------

		x : dict
			An item from the unit conversion list

		Returns
		-------

		to_unit_symbol, to_unit, from_unit_symbol, from_unit : str
			Unit symbols and names.
		"""
		if x['direction'] == 'From':
			to_unit_symbol = self.si[x['quantity']]['unit_symbol']
			to_unit = self.si[x['quantity']]['unit']
			from_unit_symbol = x['unit_symbol']
			from_unit = x['unit']
			model_name = x['direction'] + '_' + to_unit_symbol
		elif x['direction'] == 'To':
			from_unit_symbol = x['unit_symbol']
			from_unit = x['unit']
			to_unit_symbol = self.si[x['quantity']]['unit_symbol']
			to_unit = self.si[x['quantity']]['unit']
			model_name = x['direction'] + '_' + from_unit_symbol
		else:
			msg = 'A valid conversion direction did not get provided.'
			log.info(msg)

		return model_name, to_unit_symbol, to_unit, from_unit_symbol, from_unit


	def write_unit_converters(self):
		"""Generates unit conversion modelica code for each
		converter.
		"""

		for x in self.par:

			model_name, to_unit_symbol, to_unit, from_unit_symbol, from_unit = \
				self.extract_unit_strings(x)

			# set filename to final mo filename (e.g. From_degF)
			model_filename = model_name + '.mo'
			# open
			file = open(os.path.join(\
				self.outpath, model_filename), 'w')
			# write
			file.write(\
"block " + model_name + " \"Kelvin to degree Celsius temperature unit converter\"\n" \
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
"  parameter Real k = " + str(x['multiplier']) + " \"Multiplier\";\n"\
"  parameter Real p = " + str(x['adder']) + " \"Adder\";\n"\
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
"      defaultComponentName = \"" + model_name + "\",\n"\
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
"end " + model_name + ";\n"\
)

		msg = 'Wrote all converter blocks to {}.'
		log.info(msg.format(self.outpath))

		return True


	def write_unit_converter_validators(self):
		"""Generates modelica code for validation models
		"""

		validation_foldername = 'Validation'
		if not os.path.exists(os.path.join(self.outpath, validation_foldername)):
			os.makedirs(os.path.join(self.outpath, validation_foldername))

		for x in self.par:

			model_name, to_unit_symbol, to_unit, from_unit_symbol, from_unit = \
				self.extract_unit_strings(x)

			# set filename to final mo filename (e.g. From_degF)
			model_filename = model_name + '.mos'
			# open
			file = open(os.path.join(\
				self.outpath, validation_foldername, model_filename), 'w')
			# write
			file.write(\
"model "+model_name+" \"Test "+x['quantity']+" unit conversion from "+from_unit+" to "+to_unit+"\"\n"\
"  import Buildings.Controls.OBC.CDL.Conversions."+self.package_name+";\n"\
"  extends Modelica.Icons.Example;\n"\
"\n"\
"  Buildings.Controls.OBC.CDL.Continuous.Add add(k2=-1)\n"\
"    \"Difference between the calculated and expected conversion output\"\n"\
"    annotation (Placement(transformation(extent={{20,40},{40,60}})));\n"\
"  Buildings.Controls.OBC.CDL.Continuous.Add add1(k2=-1)\n"\
"    \"Difference between the calculated and expected conversion output\"\n"\
"    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));\n"\
"\n"\
"protected\n"\
"  parameter Real kin = "+str(x['validation_input'][0])+" \"Validation input\";\n"\
"  parameter Real kin1 = "+str(x['validation_input'][1])+" \"Validation input 1\";\n"\
"  parameter Real kout = "+str(x['validation_output'][0])+" \"Validation output\";\n"\
"  parameter Real kout1 = "+str(x['validation_output'][1])+" \"Validation output 1\";\n"\
"\n"\
"  Buildings.Controls.OBC.CDL.Conversions."+self.package_name+"."+model_name+" "+model_name+"\n"\
"  \"Unit converter from "+from_unit+" to "+to_unit+" \"\n"\
"    annotation (Placement(transformation(extent={{-20,40},{0,60}})));\n"\
"  Buildings.Controls.OBC.CDL.Conversions."+self.package_name+"."+model_name+" "+model_name+"1\n"\
"  \"Unit converter from "+from_unit+" to "+to_unit+" \"\n"\
"    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));\n"\
"\n"\
"  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant value(\n"\
"    final k=kin)\n"\
"    \"Value to convert\"\n"\
"    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));\n"\
"  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant value1(\n"\
"    final k=kin1)\n"\
"    \"Value to convert\"\n"\
"    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));\n"\
"  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result(\n"\
"    final k=kout)\n"\
"    \"Expected converted value\"\n"\
"    annotation (Placement(transformation(extent={{-20,10},{0,30}})));\n"\
"  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result(\n"\
"    final k=kout1)\n"\
"    \"Expected converted value\"\n"\
"    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));\n"\
"\n"\
"equation\n"\
"  connect(result.y, add.u2)\n"\
"    annotation (Line(points={{1,20},{10,20},{10,44},{18,44}}, color={0,0,127}));\n"\
"  connect(result1.y, add1.u2)\n"\
"    annotation (Line(points={{1,-60},{10,-60},{10,-36},{18,-36}}, color={0,0,127}));\n"\
"  connect(value1.y,"+model_name+"1.u)\n"\
"    annotation (Line(points={{-39,-30},{-22,-30}}, color={0,0,127}));\n"\
"  connect("+model_name+"1.y, add1.u1)\n"\
"    annotation (Line(points={{1,-30},{8,-30},{8,-24},{18,-24}}, color={0,0,127}));\n"\
"  connect("+model_name+".y, add.u1)\n"\
"    annotation (Line(points={{1,50},{10,50},{10,56},{18,56}}, color={0,0,127}));\n"\
"  connect(value.y,"+model_name+".u)\n"\
"    annotation (Line(points={{-39,50}, {-22,50}}, color={0,0,127}));\n"\
"  annotation (Icon(graphics={\n"\
"        Ellipse(lineColor = {75,138,73},\n"\
"                fillColor={255,255,255},\n"\
"                fillPattern = FillPattern.Solid,\n"\
"                extent = {{-100,-100},{100,100}}),\n"\
"        Polygon(lineColor = {0,0,255},\n"\
"                fillColor = {75,138,73},\n"\
"                pattern = LinePattern.None,\n"\
"                fillPattern = FillPattern.Solid,\n"\
"                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),\n"\
"                Diagram(coordinateSystem( preserveAspectRatio=false)),\n"\
"            experiment(StopTime=1000.0, Tolerance=1e-06),\n"\
"  __Dymola_Commands(file=\""+model_filename+"\"\n"\
"    \"Simulate and plot\"),\n"\
"    Documentation(\n"\
"    info=\"<html>\n"\
"<p>\n"\
"This model validates "+x['quantity']+" unit conversion from "+from_unit+" to "+to_unit+".""\n"\
"</p>\n"\
"</html>\",\n"\
"revisions=\"<html>\n"\
"<ul>\n"\
"<li>\n"\
"July 05, Milica Grahovac<br/>\n"\
"First implementation.\n"\
"</li>\n"\
"</ul>\n"\
"</html>\"));\n"\
"end "+model_name+";\n"\
)

		msg = 'Wrote all converter validation models to {}.'
		log.info(msg.format(os.path.join(\
			self.outpath, validation_foldername)))

		return True


	def write_mos_validation_scripts(self):
		"""Generates mos scripts for running validation models
		"""

		if not os.path.exists(self.validation_scripts_outpath):
			os.makedirs(self.validation_scripts_outpath)

		for x in self.par:

			res = self.extract_unit_strings(x)

			# set filename to final mo filename (e.g. From_degF)
			model_filename = res[0] + '.mos'
			# open
			file = open(\
				os.path.join(self.validation_scripts_outpath, model_filename), 'w')
			# write
			file.write(\
"simulateModel(\"Buildings.Controls.OBC.CDL.Conversions."+self.package_name+".Validation."+res[0]+"\", method=\"dassl\", stopTime=10, tolerance=1e-06, resultFile=\"ToC\");\n"
"\n"
"createPlot(id=1, position={20, 10, 900, 650}, subPlot=1, y={\"add.y\"}, range={0.0, 1800.0, -0.2, 0.12}, grid=true, colors={{0,0,0}});\n"
"createPlot(id=1, position={20, 10, 900, 650}, subPlot=2, y={\"add1.y\"}, range={0.0, 1800.0, -0.2, 0.12}, grid=true, colors={{0,0,0}});\n"
)

		msg = 'Wrote all mos scripts to {}.'
		log.info(msg.format(self.validation_scripts_outpath))

		return True








# walk through the create_conversions_for list and create a block, a validation block and a mos script.
