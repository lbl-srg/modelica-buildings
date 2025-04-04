import os
import re
from pdb import set_trace as bp

import logging
logging.basicConfig(level=logging.DEBUG)
log = logging.getLogger(__name__)

class UnitConversionsModeler(object):
    '''Creates OBC unit converter models and their
    validation models based on the dictionaries with
    conversion parameters. The parameters in those
    dictionaries determine the quantities, units,
    and whether the conversion is from or to a base unit.
    For example, if a base unit is an SI unit,
    the conversion between two non-SI unit is as follows:
        - non-SI unit --> SI unit --> other-non-SI unit


    Parameters
    ----------
    package_name : str
        Package folder name

    path_to_package : str
        Path to unit converter package

    path_to_validation_scripts : str
        Path to store validation models for unit converter blocks

    write_package_and_package_order : boolean
        Default: True - the scripts generates all models, package.mo and
        package.order files.

        Set to False for adding unit converter models,
        as oposed to recreating the entire package, which is recommended.
        If set to False:
        - edit the package order manually,
        - comment out any converters in the dictionaries of conversion
        parameters that do not need to be generated.

    script_name : str
        Name of this file

    Usage
    -----
    From the modelica-buildings folder run:

    - With default parameters (recommended) to recreate the entire package,
    in a bash terminal:

    .../modelica_buildings$
    python Buildings/Resources/src/Controls/OBC/UnitConversions/unit_converters.py

    package.mo and package.order get written.

    - If customizing the parameters, in a python command line:

    >>> converter_writter = UnitConverterModeler({customized kwarg values})
    >>> converter_writter.write_unit_converters()
    >>> converter_writter.write_unit_converter_validators()
    >>> converter_writter.write_mos_validation_scripts()

    Manually add models to package order as needed.

    Note
    ----
    If adding new unit converters that include a unit that Modelica
    does not recognize, append to `self.custom_units` dictionary.
    '''

    def __init__(self,\
        package_name = 'UnitConversions',
        path_to_package = \
            r'Buildings/Controls/OBC/',\
        path_to_validation_scripts = \
            r'Buildings/Resources/Scripts/Dymola/Controls/OBC/',
        write_package_and_package_order = True,
        script_name = r'unit_converters.py'):

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

        # list of units Modelica cannot recognize
        self.custom_units = ['Btu', 'Btu/h', 'hp', 'cfm', 'gal', 'inH2O', \
            'psi', 'quad', 'ton']

        # write package.mo and package.order
        self.write_package_and_package_order = write_package_and_package_order

        # this is used only to print to html documentation
        self.fullpath_to_this_script = \
            r'Buildings/Resources/src/Controls/OBC/' \
            +package_name+'/'+script_name


    def set_parameters(self):
        '''Creats a list of dictionaries, where each of these
        dictionaries represents one unit converter.

        Conversion parameters sources:
        - ASHRAE Fundamentals 2017

        SI units sources:
        - Modelica Standard Library (based on ISO 31-1992 and ISO 1000-1992)

        Other unit sources:
        - ASHRAE Fundamentals 2017, Modelica Standard Library
        '''
        conv_pardict_list = [
            # volume
            {
            'quantity' : 'volume',
            'modelica_quantity' : 'Volume',
            'unit' : 'gallon',
            'unit_symbol' : 'gal',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '0.003785412',
            'validation_input' : ['1.', '100.'],
            'validation_output' : ['1.*0.003785412', '100.*0.003785412']},
            {
            'quantity' : 'volume',
            'modelica_quantity' : 'Volume',
            'unit' : 'gallon',
            'unit_symbol' : 'gal',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./0.003785412',
            'validation_input' : ['1.*0.003785412', '100.*0.003785412'],
            'validation_output' : ['1.', '100.'],},
            # temperature
            {
            'quantity' : 'temperature',
            'modelica_quantity' : 'ThermodynamicTemperature',
            'unit' : 'degree Fahrenheit',
            'unit_symbol' : 'degF',
            'direction' : 'From',
            'adder' : '-32. * (5./9.) + 273.15',
            'multiplier' : '5./9.',
            'validation_input' : ['32.', '100. * (9./5.) + 32.'],
            'validation_output' : ['273.15', '373.15']},
            {
            'quantity' : 'temperature',
            'modelica_quantity' : 'ThermodynamicTemperature',
            'unit' : 'degree Fahrenheit',
            'unit_symbol' : 'degF',
            'direction' : 'To',
            'adder' : '(-9./5.) * 273.15 + 32',
            'multiplier' : '9./5.',
            'validation_input' : ['273.15', '373.15'],
            'validation_output' : ['32.', '100. * (9./5.) + 32.']},
            {
            'quantity' : 'temperature',
            'modelica_quantity' : 'ThermodynamicTemperature',
            'unit' : 'degree Celsius',
            'unit_symbol' : 'degC',
            'direction' : 'From',
            'adder' : '273.15',
            'multiplier' : '1.',
            'validation_input' : ['0.', '100.'],
            'validation_output' : ['273.15', '373.15']},
            {
            'quantity' : 'temperature',
            'modelica_quantity' : 'ThermodynamicTemperature',
            'unit' : 'degree Celsius',
            'unit_symbol' : 'degC',
            'direction' : 'To',
            'adder' : '-273.15',
            'multiplier' : '1.',
            'validation_input' : ['273.15', '373.15'],
            'validation_output' : ['0.', '100.']},
            # pressure
            {
            'quantity' : 'pressure',
            'modelica_quantity' : 'Pressure',
            'unit' : 'pound-force per square inch',
            'unit_symbol' : 'psi',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '6895.',
            'validation_input' : ['0.0036', '1.'],
            'validation_output' : ['0.0036*6895.', '1.*6895.']},
            {
            'quantity' : 'pressure',
            'modelica_quantity' : 'Pressure',
            'unit' : 'pound-force per square inch',
            'unit_symbol' : 'psi',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./6895.',
            'validation_input' : ['0.0036*6895.', '1.*6895.'],
            'validation_output' : ['0.0036', '1.']},
            {
            'quantity' : 'pressure',
            'modelica_quantity' : 'Pressure',
            'unit' : 'bar',
            'unit_symbol' : 'bar',
            'direction' : 'From',
            'adder' : '0',
            'multiplier' : '100000.',
            'validation_input' : ['1.', '0.00025'],
            'validation_output' : ['1.*100000.', '0.00025*100000.']},
            {
            'quantity' : 'pressure',
            'modelica_quantity' : 'Pressure',
            'unit' : 'bar',
            'unit_symbol' : 'bar',
            'direction' : 'To',
            'adder' : '0',
            'multiplier' : '1./100000.',
            'validation_input' : ['1.*100000.', '0.00025*100000.'],
            'validation_output' : ['1.', '0.00025']},
            {
            'quantity' : 'pressure',
            'modelica_quantity' : 'Pressure',
            'unit' : 'inch of water gauge (at 60 degF)',
            'unit_symbol' : 'inH2O',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '248.84',
            'validation_input' : ['25./248.84', '100000./248.84'],
            'validation_output' : ['25', '100000']},
            {
            'quantity' : 'pressure',
            'modelica_quantity' : 'Pressure',
            'unit' : 'inch of water gauge (at 60 degF)',
            'unit_symbol' : 'inH2O',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./248.84',
            'validation_input' : ['25.', '100000.'],
            'validation_output' : ['25./248.84', '100000./248.84']},
            # volume flow
            {
            'quantity' : 'volume flow',
            'modelica_quantity' : 'VolumeFlowRate',
            'unit' : 'cubic feet per minute',
            'unit_symbol' : 'cfm',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '0.000471947',
            'validation_input' : ['100.', '2000.'],
            'validation_output' : ['100.*0.000471947', '2000.*0.000471947']},
            {
            'quantity' : 'volume flow',
            'modelica_quantity' : 'VolumeFlowRate',
            'unit' : 'cubic feet per minute',
            'unit_symbol' : 'cfm',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./0.000471947',
            'validation_input' : ['100.*0.000471947', '2000.*0.000471947'],
            'validation_output' : ['100.', '2000.']},
            # Energy
            {
            'quantity' : 'energy',
            'modelica_quantity' : 'Energy',
            'unit' : 'British thermal units',
            'unit_symbol' : 'Btu',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '1055.056',
            'validation_input' : ['1.', '2.'],
            'validation_output' : ['1.*1055.056', '2.*1055.056']},
            {
            'quantity' : 'energy',
            'modelica_quantity' : 'Energy',
            'unit' : 'British thermal units',
            'unit_symbol' : 'Btu',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./1055.056',
            'validation_input' : ['1.*1055.056', '2.*1055.056'],
            'validation_output' : ['1.', '2.']},
            {
            'quantity' : 'energy',
            'modelica_quantity' : 'Energy',
            'unit' : 'quads',
            'unit_symbol' : 'quad',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '1055.56e15',
            'validation_input' : ['1.', '2.'],
            'validation_output' : ['1.*1055.56e15', '2.*1055.56e15']},
            {
            'quantity' : 'energy',
            'modelica_quantity' : 'Energy',
            'unit' : 'quads',
            'unit_symbol' : 'quad',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./1055.56e15',
            'validation_input' : ['1.*1055.56e15', '2.*1055.56e15'],
            'validation_output' : ['1.', '2.']},
            # power
            {
            'quantity' : 'power',
            'modelica_quantity' : 'Power',
            'unit' : 'British thermal units per hour',
            'unit_symbol' : 'Btu/h',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '0.2930711',
            'validation_input' : ['1./0.2930711', '1000./0.2930711'],
            'validation_output' : ['1', '1000']},
            {
            'quantity' : 'power',
            'modelica_quantity' : 'Power',
            'unit' : 'British thermal units per hour',
            'unit_symbol' : 'Btu/h',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./0.2930711',
            'validation_input' : ['1', '1000'],
            'validation_output' : ['1./0.2930711', '1000./0.2930711']},
            {
            'quantity' : 'power',
            'modelica_quantity' : 'Power',
            'unit' : 'horsepower',
            'unit_symbol' : 'hp',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '0.7457',
            'validation_input' : ['10.', '45.'],
            'validation_output' : ['10.*0.7457', '45.*0.7457']},
            {
            'quantity' : 'power',
            'modelica_quantity' : 'Power',
            'unit' : 'horsepower',
            'unit_symbol' : 'hp',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./0.7457',
            'validation_input' : ['10.*0.7457', '45.*0.7457'],
            'validation_output' : ['10.', '45.']},
            {
            'quantity' : 'power',
            'modelica_quantity' : 'Power',
            'unit' : 'ton of refrigeration',
            'unit_symbol' : 'ton',
            'direction' : 'From',
            'adder' : '0.',
            'multiplier' : '3517.',
            'validation_input' : ['1.', '100.'],
            'validation_output' : ['3517.', '351700.']},
            {
            'quantity' : 'power',
            'modelica_quantity' : 'Power',
            'unit' : 'ton of refrigeration',
            'unit_symbol' : 'ton',
            'direction' : 'To',
            'adder' : '0.',
            'multiplier' : '1./3517.',
            'validation_input' : ['3517.', '351700.'],
            'validation_output' : ['1.', '100.']},
            ]

        base_unit = {
            # SI units
            'volume' :
                {'unit' : 'cubic meter',
                 'unit_symbol' : 'm3'},
            'temperature' :
                {'unit' : 'kelvin',
                 'unit_symbol' : 'K'},
            'pressure' :
                {'unit' : 'pascal',
                 'unit_symbol' : 'Pa'},
            'energy' :
                {'unit' : 'joule',
                 'unit_symbol' : 'J'},
            'power' :
                {'unit' : 'watt',
                 'unit_symbol' : 'W'},
            'volume flow' :
                {'unit' : 'cubic meters per second',
                 'unit_symbol' : 'm3/s'},
            }

        return conv_pardict_list, base_unit

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
            to_unit_symbol = x['unit_symbol']
            to_unit = x['unit']
            from_unit_symbol = self.si[x['quantity']]['unit_symbol']
            from_unit = self.si[x['quantity']]['unit']
            model_name = x['direction'] + '_' + to_unit_symbol
        else:
            msg = 'A valid conversion direction did not get provided.'
            log.info(msg)

        if '/' in model_name:
            model_name = re.sub('/', 'Per', model_name)
            # Use PerHour rather than Perh
            model_name = re.sub('Perh', 'PerHour', model_name)

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

            if not os.path.exists(self.package_path):
                os.makedirs(self.package_path)
            # open
            file = open(os.path.join(\
                self.package_path, model_filename), 'w')
            # write
            file.write(\
            "within Buildings.Controls.OBC.UnitConversions;\n"\
            "block " + model_name + " \"Block that converts "+x['quantity']+" from "+from_unit+" to "+to_unit+"\"\n" \
            "\n"\
            "  Buildings.Controls.OBC.CDL.Interfaces.RealInput u(\n")
            if from_unit_symbol not in self.custom_units:
                file.write(\
                "    final unit = \"" + from_unit_symbol + "\",\n")
            file.write(\
            "    final quantity = \""+x['modelica_quantity']+"\")\n"\
            "    \""+x['quantity'].capitalize()+" in " + from_unit +"\"\n"\
            "    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));\n"\
            "\n"\
            "  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(\n")
            if to_unit_symbol not in self.custom_units:
                file.write(\
                "    final unit = \"" + to_unit_symbol + "\",\n")
            file.write(\
            "    final quantity = \""+x['modelica_quantity']+"\")\n"\
            "    \""+x['quantity'].capitalize() +" in " + to_unit +"\"\n"\
            "    annotation (Placement(transformation(extent={{100,-20},{140,20}})));\n"\
            "\n"\
            "protected\n")
            if int(eval(x['adder'])) != 0:
                file.write(\
            "  constant Real k = " + x['multiplier'] + " \"Multiplier\";\n"\
            "  constant Real p = " + x['adder'] + " \"Adder\";\n"
            "\n"\
            "  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(\n"\
            "    final k = k) \"Gain factor\"\n"\
            "    annotation (Placement(transformation(extent={{-68,-10},{-48,10}})));\n"\
            "\n"\
            "  Buildings.Controls.OBC.CDL.Reals.AddParameter conv(\n"\
            "    final p = p) \"Unit converter\"\n"\
            "    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));\n"\
            "\n")
            else:
                file.write(\
            "  constant Real k = " + x['multiplier'] + " \"Multiplier\";\n"\
            "\n"\
            "  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter conv(\n"\
            "    final k = k) \"Unit converter\"\n"\
            "    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));\n"\
            "\n")
            if int(eval(x['adder'])) != 0:
                file.write(\
            "equation\n"\
            "  connect(conv.y, y)\n"\
            "    annotation (Line(points={{12,0},{60,0},{60,0},{120,0}},color={0,0,127}));\n"\
            "  connect(u, gai.u)\n"\
            "    annotation (Line(points={{-120,0},{-70,0}}, color={0,0,127}));\n"\
            "  connect(gai.y, conv.u)\n"\
            "    annotation (Line(points={{-46,0},{-12,0}}, color={0,0,127}));\n"\
            "\n")
            else:
                file.write(\
            "equation\n"\
            "  connect(u, conv.u)\n"\
            "    annotation (Line(points={{-120,0},{-12,0}},color={0,0,127}));\n"\
            "  connect(conv.y, y)\n"\
            "    annotation (Line(points={{12,0},{120,0}},color={0,0,127}));\n")
            file.write(\
            "  annotation (\n"\
            "      defaultComponentName = \"" + model_name[0].lower() + model_name[1:]  + "\",\n"\
            "    Icon(graphics={\n"\
            "        Rectangle(\n"\
            "          extent={{-100,-100},{100,100}},\n"\
            "          lineColor={0,0,127},\n"\
            "          fillColor={255,255,255},\n"\
            "          fillPattern=FillPattern.Solid),\n"\
            "        Line(points={{20,58}}, color={28,108,200}),\n"\
            "        Text(\n"\
            "          textColor={0,0,255},\n"\
            "          extent={{-150,110},{150,150}},\n"\
            "          textString=\"%name\"),\n"\
            "        Text(\n"\
            "          extent={{-80,50},{0,10}},\n"\
            "          textColor={0,0,127},\n"\
            "          textString=\"" + from_unit_symbol + "\"),\n"\
            "        Text(\n"\
            "          extent={{10,-70},{90,-30}},\n"\
            "          textColor={0,0,127},\n"\
            "          textString=\"" + to_unit_symbol + "\"),\n"\
            "        Polygon(\n"\
            "        points={{90,0},{30,20},{30,-20},{90,0}},\n"\
            "        lineColor={191,0,0},\n"\
            "        fillColor={191,0,0},\n"\
            "        fillPattern=FillPattern.Solid),\n"\
            "        Line(points={{-90,0},{30,0}}, color={191,0,0})}),\n"\
            "        Documentation(info=\"<html>\n"\
            "<p>\n"\
            "Converts "+x['quantity']+" given in " + from_unit + " [" + from_unit_symbol + "] to " + to_unit + " [" + to_unit_symbol + "].\n"\
            "</p>\n"\
            "</html>\", revisions=\"<html>\n"\
            "<ul>\n"\
            "<li>\n"\
            "November 29, 2021, by Michael Wetter:<br/>\n"\
            "Regenerated files with <code>Text</code> annotation using now the <code>textColor</code> attribute\n"\
            "rather than the deprecated <code>lineColor</code> attribute.\n"\
            "</li>\n"\
            "<li>\n"\
            "July 05, 2018, by Milica Grahovac:<br/>\n"\
            "Generated with <code>"+ self.fullpath_to_this_script +"</code>.<br/>\n" \
            "First implementation.\n"\
            "</li>\n"\
            "</ul>\n"\
            "</html>\"));\n"\
            "end " + model_name + ";\n"\
            )

        msg = 'Wrote all converter blocks to {}.'
        log.info(msg.format(self.package_path))

        if self.write_package_and_package_order:
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
            """within Buildings.Controls.OBC;
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
November 29, 2021, by Michael Wetter:<br/>
Regenerated files with <code>Text</code> annotation using now the <code>textColor</code> attribute
rather than the deprecated <code>lineColor</code> attribute.
</li>
<li>
August 1, 2018, by Milica Grahovac:<br/>
Generated with <code>""" + self.fullpath_to_this_script + """</code>.<br/>
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
    radius=25.0),
        Polygon(
        points={{92,-42},{32,-22},{32,-62},{92,-42}},
        lineColor={191,0,0},
        fillColor={191,0,0},
        fillPattern=FillPattern.Solid),
        Line(points={{-88,-42},{32,-42}},
            color={191,0,0}),
        Text(
          extent={{-72,78},{72,6}},
          textColor={0,0,0},
        textString="SI")}));
end """+self.package_name+""";
""")

        else:
            msg = 'Make sure to update the package.order.'
            log.info(msg)

        return True


    def write_unit_converter_validators(self):
        """Generates modelica code for validation models

        Tests validate two data points for each conversion
        """

        to_lower = lambda s: s[:1].lower() + s[1:] if s else ''

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
            "within Buildings.Controls.OBC.UnitConversions.Validation;\n"\
            "model "+model_name+" \"Validation model for unit conversion from "+from_unit+" to "+to_unit+"\"\n"\
            "  extends Modelica.Icons.Example;\n"\
            "\n"\
            "  Buildings.Controls.OBC.CDL.Reals.Subtract sub\n"\
            "    \"Difference between the calculated and expected conversion output\"\n"\
            "    annotation (Placement(transformation(extent={{20,40},{40,60}})));\n"\
            "  Buildings.Controls.OBC.CDL.Reals.Subtract sub1\n"\
            "    \"Difference between the calculated and expected conversion output\"\n"\
            "    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));\n"\
            "\n"\
            "protected\n"\
            "  parameter Real kin = "+x['validation_input'][0]+" \"Validation input\";\n"\
            "  parameter Real kin1 = "+x['validation_input'][1]+" \"Validation input 1\";\n"\
            "  parameter Real kout = "+x['validation_output'][0]+" \"Validation output\";\n"\
            "  parameter Real kout1 = "+x['validation_output'][1]+" \"Validation output 1\";\n"\
            "\n"\
            "  Buildings.Controls.OBC."+self.package_name+"."+model_name+" "+to_lower(model_name)+"\n"\
            "  \"Unit converter from "+from_unit+" to "+to_unit+" \"\n"\
            "    annotation (Placement(transformation(extent={{-20,40},{0,60}})));\n"\
            "  Buildings.Controls.OBC."+self.package_name+"."+model_name+" "+to_lower(model_name)+"1\n"\
            "  \"Unit converter from "+from_unit+" to "+to_unit+" \"\n"\
            "    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));\n"\
            "\n"\
            "  Buildings.Controls.OBC.CDL.Reals.Sources.Constant value(\n"\
            "    final k=kin)\n"\
            "    \"Value to convert\"\n"\
            "    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));\n"\
            "  Buildings.Controls.OBC.CDL.Reals.Sources.Constant value1(\n"\
            "    final k=kin1)\n"\
            "    \"Value to convert\"\n"\
            "    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));\n"\
            "  Buildings.Controls.OBC.CDL.Reals.Sources.Constant result(\n"\
            "    final k=kout)\n"\
            "    \"Expected converted value\"\n"\
            "    annotation (Placement(transformation(extent={{-20,10},{0,30}})));\n"\
            "  Buildings.Controls.OBC.CDL.Reals.Sources.Constant result1(\n"\
            "    final k=kout1)\n"\
            "    \"Expected converted value\"\n"\
            "    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));\n"\
            "\n"\
            "equation\n"\
            "  connect(result.y, sub.u2)\n"\
            "    annotation (Line(points={{2,20},{10,20},{10,44},{18,44}}, color={0,0,127}));\n"\
            "  connect(result1.y, sub1.u2)\n"\
            "    annotation (Line(points={{2,-60},{10,-60},{10,-36},{18,-36}}, color={0,0,127}));\n"\
            "  connect(value1.y,"+to_lower(model_name)+"1.u)\n"\
            "    annotation (Line(points={{-38,-30},{-22,-30}}, color={0,0,127}));\n"\
            "  connect("+to_lower(model_name)+"1.y, sub1.u1)\n"\
            "    annotation (Line(points={{2,-30},{8,-30},{8,-24},{18,-24}}, color={0,0,127}));\n"\
            "  connect("+to_lower(model_name)+".y, sub.u1)\n"\
            "    annotation (Line(points={{2,50},{10,50},{10,56},{18,56}}, color={0,0,127}));\n"\
            "  connect(value.y,"+to_lower(model_name)+".u)\n"\
            "    annotation (Line(points={{-38,50}, {-22,50}}, color={0,0,127}));\n"\
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
            "            experiment(StopTime=10.0, Tolerance=1e-06),\n"\
            "  __Dymola_Commands(file=\"modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/"+self.package_name+'/Validation/'+model_name+".mos"+"\"\n"\
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
            "November 29, 2021, by Michael Wetter:<br/>\n"\
            "Regenerated files with <code>Text</code> annotation using now the <code>textColor</code> attribute\n"\
            "rather than the deprecated <code>lineColor</code> attribute.\n"\
            "</li>\n"\
            "<li>\n"\
            "July 05, 2018, Milica Grahovac<br/>\n"\
            "Generated with <code>"+ self.fullpath_to_this_script +"</code>.<br/>\n" \
            "First implementation.\n"\
            "</li>\n"\
            "</ul>\n"\
            "</html>\"));\n"\
            "end "+model_name+";\n"\
            )

        msg = 'Wrote all converter validation models to {}.'
        log.info(msg.format(self.val_pack_path))

        if self.write_package_and_package_order:
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
            "within Buildings.Controls.OBC."+self.package_name+";\n"\
            "package Validation \"Collection of models that validate the unit conversion blocks of the CDL\"\n"\
            "\n"\
            "annotation (preferredView=\"info\", Documentation(info=\"<html>\n"\
            "<p>\n"\
            "This package contains models that validate the blocks in\n"\
            """<a href=\\"modelica://Buildings.Controls.OBC."""+self.package_name+"""\\">\n"""\
            "Buildings.Controls.OBC."+self.package_name+"</a>.\n"\
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
            "end Validation;\n"\
            )
        else:
            msg = 'Make sure to update the package.order.'
            log.info(msg)

        return True


    def write_mos_validation_scripts(self):
        """Generates mos scripts for running validation models
        """

        if not os.path.exists(self.mospath):
            os.makedirs(self.mospath)

        for x in self.par:

            res = self.extract_unit_strings(x)

            # set filename to final mo filename (e.g. From_degF)
            model_name = res[0]
            model_filename = model_name + '.mos'
            # open
            file = open(os.path.join(self.mospath, model_filename), 'w')
            # write
            file.write(\
            "simulateModel(\"Buildings.Controls.OBC."+self.package_name+".Validation."+model_name+"\", method=\"dassl\", stopTime=10, tolerance=1e-06, resultFile=\""+model_name+"\");\n"
            "\n"
            "createPlot(id=1, position={20, 10, 900, 650}, subPlot=1, y={\"sub.y\"}, range={0.0, 1800.0, -0.2, 0.12}, grid=true, colors={{0,0,0}});\n"
            "createPlot(id=1, position={20, 10, 900, 650}, subPlot=2, y={\"sub1.y\"}, range={0.0, 1800.0, -0.2, 0.12}, grid=true, colors={{0,0,0}});\n"
            )

        msg = 'Wrote all mos scripts to {}.'
        log.info(msg.format(self.mospath))

        return True

def main():
    conv = UnitConversionsModeler()
    conv.write_unit_converters()
    conv.write_unit_converter_validators()
    conv.write_mos_validation_scripts()

if __name__ == "__main__":
    main()
