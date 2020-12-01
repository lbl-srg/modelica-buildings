within Buildings.Controls.OBC.UsersGuide;
class Conventions "Conventions"
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
The following variables are frequently used:
<ul>
<li><code>T</code> for temperature,</li>
<li><code>p</code> for pressure,</li>
<li><code>dp</code> for pressure difference,</li>
<li><code>m_flow</code> for mass flow rate and</li>
<li><code>V_flow</code> for volumetric flow rate,</li>
<li><code>k</code> for the gain of PID controller,</li>
<li><code>Ti</code> for the time constant of integrator block of PID controller,</li>
<li><code>Td</code> for the time constant of derivative block of PID controller.</li>
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
Prefix <code>use_</code> for conditionally enabled input signals, such as <code>use_TMix</code>
for enabling an input connector for the measured mixed air temperature.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller\">Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Controller</a>.
</li>
<li>
Prefix <code>have_</code> if a controller has a certain input, such as <code>have_CO2Sen</code>
in <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller</a> if the zone has a CO<sub>2</sub> sensor.
</li>
<li>
Suffix <code>_flow</code> for a flow variable, such as <code>V_flow</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Controller</a>.
</li>
<li>
Suffix <code>_nominal</code> for the design or nominal capacity, i.e., <code>V_flow_nominal</code> is the design volume flow rate.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves</a>.
</li>
<li>
Suffix <code>Set</code> for set point.
</li>
<li>
Suffix <code>Min</code> (<code>Max</code>) for minimum (maximum),
such as in <code>TSupSetMin</code> for minimum supply temperature set point.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a> 
</li>
</ul>
</li>
</ol>

<p>
Following table shows some examples of the commonly used names:
</p>
<table summary=\"summary\" border=\"1\">
<tr><td colspan=\"2\"><b>Instance names</b></td></tr>
<tr><th>Name</th><th>Comments</th></tr>
<tr><td><code>TOut</code> (<code>hOut</code>)</td><td>Outdoor air temperature (enthalpy)</td></tr>
<tr><td><code>TZonHeaSet</code> (<code>TZonCooSet</code>)</td><td>Zone heating (cooling) setpoint temperature</td></tr>
<tr><td><code>VDis_flow</code></td><td>Measured discharge airflow rate</td></tr>
<tr><td><code>uOpeMod</code></td><td>Zone group operating mode</td></tr>
<tr><td><code>uResReq</code></td><td>Number of reset requests</td></tr>
<tr><td><code>uSupFan</code></td><td>Supply fan enabling status, true: fan is enabled</td></tr>
<tr><td><code>uDam</code></td><td>Measured damper position</td></tr>
<tr><td><code>uHea</code> (<code>uCoo</code>)</td><td>Heating (cooling) loop signal</td></tr>
<tr><td><code>yPosMin</code> (<code>yPosMax</code>)</td><td>Minimum (maximum) position</td></tr>
<tr><td><code>yDamSet</code> (<code>yValSet</code>)</td><td>Damper (valve) position setpoint</td></tr>
<tr><td><code>yHeaCoi</code> (<code>yCooCoi</code>)</td><td>Heating (cooling) coil control signal</td></tr>
<tr><td colspan=\"2\"><b>Parameter names</b></td></tr>
<tr><th>Name</th> <th>Comments</th></tr>
<tr><td><code>use_TMix</code></td><td>Set to true if mixed air temperature measurement is used</td></tr>
<tr><td><code>have_occSen</code> (<code>have_winSen</code>)</td><td>Set to true if the zone has occupancy (window) sensor</td></tr>
<tr><td><code>AFlo</code></td><td>Area of the zone</td></tr>
<tr><td><code>VDisHeaSetMax_flow</code> (<code>VDisCooSetMax_flow</code>)</td><td>Zone maximum heating (cooling) airflow setpoint</td></tr>
<tr><td><code>VOutPerAre_flow</code> (<code>VOutPerPer_flow</code>)</td><td>Outdoor air rate per unit area (person)</td></tr>
<tr><td><code>pMinSet</code> (<code>pMaxSet</code>)</td><td>Minimum (maximum) pressure setpoint for fan speed control</td></tr>
<tr><td><code>TSupSetMin</code> (<code>TSupSetMax</code>)</td><td>Lowest (Highest) cooling supply air temperature</td></tr>
<tr><td><code>TOccHeaSet</code> (<code>TUnoHeaSet</code>)</td><td>Zone occupied (unoccupied) heating setpoint</td></tr>
<tr><td><code>TZonCooMax</code> (<code>TZonCooMin</code>)</td><td>Maximum (minimum) zone cooling setpoint when cooling is on</td></tr>
<tr><td><code>retDamPhyPosMax</code> (<code>outDamPhyPosMax</code>)</td><td>Physically fixed maximum position of the return (outdoor) air damper</td></tr>
<tr><td><code>samplePeriod</code></td><td>Sample period</td></tr>
<tr><td><code>zonDisEffHea</code> (<code>zonDisEffCoo</code>)</td><td>Zone air distribution effectiveness during heating (cooling)</td></tr>
<tr><td><code>VOutMin_flow</code></td><td>Calculated minimum outdoor airflow rate</td></tr>
</table>
<br/>

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
</html>"),
    Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(origin={-4.167,-15},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,-50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
          smooth=Smooth.Bezier),
        Ellipse(origin={7.5,56.5},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-12.5,-12.5},{12.5,12.5}})}));
end Conventions;
