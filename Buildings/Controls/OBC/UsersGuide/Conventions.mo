within Buildings.Controls.OBC.UsersGuide;
class Conventions "Conventions"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The <code>Buildings.Control.OBC</code> package uses the following conventions,
which are based on the conventions of the <code>Buildings</code> Library.
</p>

<h4>Naming</h4>
<ol>
<li>
Class names of models, blocks and packages should start with an upper-case letter and be a
noun or a noun with a combination of adjectives and nouns.
Use camel-case notation to combine multiple words, such as <code>SupplyTemperature</code>.
Don't repeat higher level package names, for example, rather than <code>Reheat.ReheatDamperValves</code>,
use <code>Reheat.DamperValves</code>.
</li>
<li>
Instance names should be a combination of the first three
characters of a word, such as <code>preDro</code> for pressure drop model.
Where applicable, a single character can be used if this is generally understood, such
as <code>T</code> for temperature, <code>p</code> for pressure, <code>u</code> for control input
and <code>y</code> for control output signal. As needed, these can be augmented, for example
a controller that outputs a control signal for a valve and a damper may output <code>yVal</code>
and <code>yDam</code>.
</li>
<li>
The following variables are frequently used for physical quantities:
<ul>
<li><code>T</code> for temperature,</li>
<li><code>p</code> for pressure,</li>
<li><code>dp</code> for pressure difference,</li>
<li><code>m_flow</code> for mass flow rate and</li>
<li><code>V_flow</code> for volumetric flow rate.</li>
</ul>
</li>
<li>
Control input signals usually start with <code>u</code> and control output signals usually start with <code>y</code>,
unless use of the physical quantity is clearer.
</li>
<li>
The following strings are frequently used:
<ul>
<li>
Prefix <code>use_</code> for conditionally enabled input signals, such as <code>use_T_in</code>
for enabling an input connector for temperature.
See <a href=\"modelica://Buildings.Fluid.Sources.Boundary_pT\">Buildings.Fluid.Sources.Boundary_pT</a>.
</li>
<li>
Prefix <code>have_</code> if a controller has a certain input, such as <code>have_CO2Sen</code>
in <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller</a> if the zone has a CO<sub>2</sub> sensor.
</li>
<li>
Suffix <code>_flow</code> for a flow variable, such as <code>Q_flow</code> and <code>m_flow</code>.
See <a href=\"Buildings.Fluid.Sensors.VolumeFlowRate\">
Buildings.Fluid.Sensors.VolumeFlowRate</a>.
</li>
<li>
Suffix <code>_nominal</code> for the design or nominal capacity, i.e., <code>Q_flow_nominal</code> is the
capacity of a device that it has at full load, and <code>m_flow_nominal</code> is the design mass flow rate.
See <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>.
</li>
<li>
Suffix <code>_small</code> for a small value which is typically used for regularization (to ensure
a numerically robust implementation).
</li>
<li>
Suffix <code>Set</code> for set point.
</li>
<li>
Suffix <code>Min</code> (<code>Max</code>) for minimum (maximum),
such as in <code>TSupSetMin</code> for minimum supply temperature set point.
</li>
</ul>
</li>
<li>
The two connectors of a domain that have identical declarations
and different icons are usually distinguished by <code>_a</code>, <code>_b</code>
or <code>_p</code>, <code>_n</code>.
Examples are fluid ports <code>port_a</code> and <code>port_b</code>
or electrical connectors
<code>terminal_p</code> and <code>terminal_n</code>.
</li>
</ol>

<h4>Documentation</h4>
<ol>
<li>
In the html documentation, start additional headings with
<code>h4</code>.
(The headings <code>h1, h2, h3</code> must not be used,
because they are utilized from the automatically generated
documentation.)
</li>
<li>
Comments must be added to each class (package, model, function etc.).
</li>
<li>
The first character should be upper case.
</li>
<li>
For one-line comments of parameters, variables and classes, no period should be used at the end of the comment.
</li>
</ol>

<h4>Graphical display</h4>
<ol>
<li>
The instance name of a component is always displayed in its icon
(using the text string \"%name\") in blue color.
</li>
<li>
A connector class has the instance
name definition in the diagram layer and usually not in the icon layer, unless this helps with usability.
</li>
<li>
The value of main parameters, such as nominal capacity, are displayed
in the icon in black color in a smaller font size as the instance name
if this helps with usability.
</li>
</ol>

<h4>Miscellaneous</h4>
<ol>
<li>
Where applicable, all variable must have units, also if the variable is protected.
</li>
<li>
Each class (i.e., model, block and function) must be used in an example or validation case.
</li>
</ol>
</html>"));
end Conventions;
