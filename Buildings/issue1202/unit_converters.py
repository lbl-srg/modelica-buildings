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
    package_name : str
        Package folder name

    path_to_package : str
        Path to unit converter package

    path_to_validation_scripts : str
        Path to store validation models for unit converter blocks


	'''

	def __init__(self,\
		package_name = 'UnitConverters',
		path_to_package = \
		    r'/home/mg/repos/modelica-buildings/Buildings/Controls/OBC/CDL/Conversions',\
		path_to_validation_scripts = \
			r'/home/mg/repos/modelica-buildings/Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Conversions'):

		self.par, self.si = self.set_parameters()

		self.package_name = package_name
		self.val_pack_name = 'Validation'

		# path to unit converter package folder
		self.package_path = os.path.join(path_to_package, package_name)

		# path to unit converter validation package folder
		self.val_pack_path = os.path.join(self.package_path, self.val_pack_name)

		# path to the mos scripts folder
		self.mospath = os.path.join(path_to_validation_scripts, \
			self.package_name, self.val_pack_name)


	def set_parameters(self):
		'''Creats a list of dictionaries, where each of these
		dictionaries represents one unit converter.

		Conversion parameters sources:
		- ASHRAE Fundamentals 2017
		- Recknagel 09/10
		'''
		conv_pardict_list = [
			# temperature
            {
			'quantity' : 'temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree fahrenheit',
			'unit_symbol' : 'degF',
			'direction' : 'From',
			'adder' : '-32. * (5./9.) + 273.15',
			'multiplier' : '5./9.',
			'validation_input' : ['32.', '100.*(9./5.) + 32.'], # tests are using two points to chech the conversion
			'validation_output' : ['273.15', '373.15']},
			{
			'quantity' : 'temperature',
		    'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree fahrenheit',
			'unit_symbol' : 'degF',
			'direction' : 'To',
			'adder' : '(-9./5.)*273.15 + 32',
			'multiplier' : '9./5.',
			'validation_input' : ['273.15', '373.15'],
			'validation_output' : ['32.', '100.*(9./5.) + 32.']},
			{
			'quantity' : 'temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree celsius',
			'unit_symbol' : 'degC',
			'direction' : 'From',
			'adder' : '273.15',
			'multiplier' : '1.',
			'validation_input' : ['0', '100.'],
			'validation_output' : ['273.15', '373.15']},
			{
			'quantity' : 'temperature',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'degree celsius',
			'unit_symbol' : 'degC',
			'direction' : 'To',
			'adder' : '-273.15',
			'multiplier' : '1.',
			'validation_input' : ['273.15', '373.15'],
			'validation_output' : ['0', '100.']},
			# pressure
			{
			'quantity' : 'pressure',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'pound-force per square inch',
			'unit_symbol' : 'psi',
			'direction' : 'From',
			'adder' : '0.',
			'multiplier' : '6895.',
			'validation_input' : ['.0036', '1.'],
			'validation_output' : ['.0036 * 6895', '1. * 6895.)']},
			{
			'quantity' : 'pressure',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'pound-force per square inch',
			'unit_symbol' : 'psi',
			'direction' : 'To',
			'adder' : '0.',
			'multiplier' : '1./6895.',
			'validation_input' : ['.0036 * 6895', '1. * 6895.)'],
			'validation_output' : ['.0036', '1.']}
			{
			'quantity' : 'pressure',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'bar',
			'unit_symbol' : 'bar',
			'direction' : 'From',
			'adder' : '0',
			'multiplier' : '100000.',
			'validation_input' : ['1.', '.00025'],
			'validation_output' : ['1.*100000.', '.00025*100000.']},
			{
			'quantity' : 'pressure',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'bar',
			'unit_symbol' : 'bar',
			'direction' : 'To',
			'adder' : '0',
			'multiplier' : '1./100000.',
			'validation_input' : ['1.*100000.', '.00025*100000.'],
			'validation_output' : ['1.', '.00025']},
			{
			'quantity' : 'pressure',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'inch of water gauge (at 60 degF)',
			'unit_symbol' : 'inH2O',
			'direction' : 'From',
			'adder' : '0.',
			'multiplier' : '248.84',
			'validation_input' : ['25./248.84', '100000./248.84'],
			'validation_output' : ['25', '100000']},
			{
			'quantity' : 'pressure',
			'modelica_quantity' : 'ThermodynamicTemperature',
			'unit' : 'inch of water gauge (at 60 degF)',
			'unit_symbol' : 'inH2O',
			'direction' : 'To',
			'adder' : '0.',
			'multiplier' : '1./248.84',
			'validation_input' : ['25.', '100000.'],
			'validation_output' : ['25./248.84', '100000./248.84']},
			# volume flow
			{
			'quantity' : '',
			'modelica_quantity' : '',
			'unit' : '',
			'unit_symbol' : '',
			'direction' : 'From',
			'adder' : '',
			'multiplier' : '',
			'validation_input' : ['', ''],
			'validation_output' : ['', '']},
			{
			'quantity' : '',
			'modelica_quantity' : '',
			'unit' : '',
			'unit_symbol' : '',
			'direction' : 'To',
			'adder' : '',
			'multiplier' : '',
			'validation_input' : ['', ''],
			'validation_output' : ['', '']},
			{
			'quantity' : '',
			'modelica_quantity' : '',
			'unit' : '',
			'unit_symbol' : '',
			'direction' : 'From',
			'adder' : '',
			'multiplier' : '',
			'validation_input' : ['', ''],
			'validation_output' : ['', '']},
			{
			'quantity' : '',
			'modelica_quantity' : '',
			'unit' : '',
			'unit_symbol' : '',
			'direction' : 'To',
			'adder' : '',
			'multiplier' : '',
			'validation_input' : ['', ''],
			'validation_output' : ['', '']},
			{
			'quantity' : '',
			'modelica_quantity' : '',
			'unit' : '',
			'unit_symbol' : '',
			'direction' : 'From',
			'adder' : '',
			'multiplier' : '',
			'validation_input' : ['', ''],
			'validation_output' : ['', '']},
			{
			'quantity' : '',
			'modelica_quantity' : '',
			'unit' : '',
			'unit_symbol' : '',
			'direction' : 'To',
			'adder' : '',
			'multiplier' : '',
			'validation_input' : ['', ''],
			'validation_output' : ['', '']},

			inches of water gauge - inwg
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
			model_name = x['direction'] + '_' + from_unit_symbol
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
		package_order_name_list = ['Validation']

		for x in self.par:

			model_name, to_unit_symbol, to_unit, from_unit_symbol, from_unit = \
				self.extract_unit_strings(x)

			# set filename to final mo filename (e.g. From_degF)
			model_filename = model_name + '.mo'

			package_order_name_list.append(model_name)

			# open
			file = open(os.path.join(\
				self.package_path, model_filename), 'w')
			# write
			file.write(\
"block " + model_name + " \"Kelvin to degree Celsius temperature unit converter\"\n" \
"\n"\
"  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(\n" \
"    final unit = \"" + from_unit_symbol + "\",\n"\
"    final quantity = \""+x['modelica_quantity']+"\")\n"\
"    \"Temparature in " + from_unit +"\"\n"\
"    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),\n"\
"      iconTransformation(extent={{-140,-20},{-100,20}})));\n"\
"\n"\
"  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(\n"\
"    final unit = \"" + to_unit_symbol + "\",\n"\
"    final quantity = \""+x['modelica_quantity']+"\")\n"\
"    \"Temparature in " + from_unit +"\"\n"\
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
		log.info(msg.format(self.package_path))

		# write validaton package.order
		package_order_name_list.sort()
		# open
		file = open(os.path.join(self.package_path, 'package.order'), 'w')
		# write
		for model_name in package_order_name_list:
			file.write(model_name + "\n")

		# write package.mo
		file = open(os.path.join(self.package_path, 'package.mo'), 'w')
		file.write(\
"""within Buildings.Controls.OBC.CDL.Conversions;
package """+self.package_name+""" "Package with blocks for unit conversion"

annotation (
Documentation(
info="<html>
<p>
Package with blocks for unit conversions.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 1, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}));
end """+self.package_name+""";""")

		return True


	def write_unit_converter_validators(self):
		"""Generates modelica code for validation models
		"""

		validation_foldername = 'Validation'
		if not os.path.exists(self.val_pack_path):
			os.makedirs(self.val_pack_path)

		package_order_name_list = []

		for x in self.par:

			model_name, to_unit_symbol, to_unit, from_unit_symbol, from_unit = \
				self.extract_unit_strings(x)

			# set filename to final mo filename (e.g. From_degF)
			model_filename = model_name + '.mo'

			package_order_name_list.append(model_name)

			# open
			file = open(os.path.join(self.val_pack_path, model_filename), 'w')
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
"  parameter Real kin = "+x['validation_input'][0]+" \"Validation input\";\n"\
"  parameter Real kin1 = "+x['validation_input'][1]+" \"Validation input 1\";\n"\
"  parameter Real kout = "+x['validation_output'][0]+" \"Validation output\";\n"\
"  parameter Real kout1 = "+x['validation_output'][1]+" \"Validation output 1\";\n"\
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
"  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant result1(\n"\
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
"  __Dymola_Commands(file=\"modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Conversions/"+self.package_name+'/Validation/'+model_name+".mos"+"\"\n"\
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
		log.info(msg.format(self.val_pack_path))

		# write validaton package.order
		package_order_name_list.sort()
		# open
		file = open(os.path.join(self.val_pack_path, 'package.order'), 'w')
		# write
		for model_name in package_order_name_list:
			file.write(model_name + "\n")

		# write validation package.mo
		file = open(os.path.join(self.val_pack_path, 'package.mo'), 'w')
		file.write(\
"within Buildings.Controls.OBC.CDL.Conversions."+self.package_name+";\n"\
"package Validation \"Collection of models that validate the unit conversion blocks of the CDL\"\n"\
"\n"\
"annotation (preferredView=\"info\", Documentation(info=\"<html>\n"\
"<p>\n"\
"This package contains models that validate the blocks in\n"\
"""<a href=\\"modelica://Buildings.Controls.OBC.CDL.Conversions."""+self.package_name+"""\\">\n"""\
"Buildings.Controls.OBC.CDL.Conversions."+self.package_name+"</a>.\n"\
"</p>\n"\
"<p>\n"\
"The examples plot various outputs, which have been verified against\n"\
"analytical solutions. These model outputs are stored as reference data to\n"\
"allow continuous validation whenever models in the library change.\n"\
"</p>\n"\
"</html>\"),\n"\
"    Icon(graphics={\n"\
"        Rectangle(\n"\
"          lineColor={200,200,200},\n"\
"          fillColor={248,248,248},\n"\
"          fillPattern=FillPattern.HorizontalCylinder,\n"\
"          extent={{-100,-100},{100,100}},\n"\
"          radius=25.0),\n"\
"        Rectangle(\n"\
"          lineColor={128,128,128},\n"\
"          extent={{-100,-100},{100,100}},\n"\
"          radius=25.0),\n"\
"        Polygon(\n"\
"          origin={8,14},\n"\
"          lineColor={78,138,73},\n"\
"          fillColor={78,138,73},\n"\
"          pattern=LinePattern.None,\n"\
"          fillPattern=FillPattern.Solid,\n"\
"          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}));\n"\
"end Validation;"\
)

		return True


	def write_mos_validation_scripts(self):
		"""Generates mos scripts for running validation models
		"""

		if not os.path.exists(self.mospath):
			os.makedirs(self.mospath)

		for x in self.par:

			res = self.extract_unit_strings(x)

			# set filename to final mo filename (e.g. From_degF)
			model_filename = res[0] + '.mos'
			# open
			file = open(os.path.join(self.mospath, model_filename), 'w')
			# write
			file.write(\
"simulateModel(\"Buildings.Controls.OBC.CDL.Conversions."+self.package_name+".Validation."+res[0]+"\", method=\"dassl\", stopTime=10, tolerance=1e-06, resultFile=\"ToC\");\n"
"\n"
"createPlot(id=1, position={20, 10, 900, 650}, subPlot=1, y={\"add.y\"}, range={0.0, 1800.0, -0.2, 0.12}, grid=true, colors={{0,0,0}});\n"
"createPlot(id=1, position={20, 10, 900, 650}, subPlot=2, y={\"add1.y\"}, range={0.0, 1800.0, -0.2, 0.12}, grid=true, colors={{0,0,0}});\n"
)

		msg = 'Wrote all mos scripts to {}.'
		log.info(msg.format(self.mospath))

		return True








# walk through the create_conversions_for list and create a block, a validation block and a mos script.
