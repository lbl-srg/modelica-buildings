within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data;
record PipeDataAIT151218
  "Experimental data from AIT monitoring data December 18, 2015"
    extends BaseClasses.PipeDataBaseDefinition(
      final nCol = 10,
      final filNam = Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/Data/Fluid/FixedResistances/Validation/PlugFlowPipes/PipeDataAIT151218.mos"));
     annotation (Documentation(revisions="<html>
<ul>
<li>
March 7, 2020, by Michael Wetter:<br/>
Replaced measured data from specification in Modelica file to external table,
as this reduces the computing time.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1289\"> #1289</a>.
</li>
<li>
December 18, 2015 by Daniele Basciotti:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p><b><span style=\"color: #008000;\">Overview</span></b> </p>
<p>This record contains data of a real disitrict heating network for week-long period (23-29 Januar 2009) monitored by the Austrian Institut for Technology.</p>
<p> Pipes are layed underground

<p><b><span style=\"color: #008000;\">Data structure</span></b> </p>
<p>Column 1: Time in s </p>
<p>Column 2: Temperature in point 1 in K</p>
<p>Column 3: Temperature in point 2 in K</p>
<p>Column 4: Temperature in point 3 in K</p>
<p>Column 5: Temperature in point 4 in K</p>
<p>Column 6: Mass flow rate in point 1 in kg/s</p>
<p>Column 7: Mass flow rate in point 2 in kg/s</p>
<p>Column 8: Mass flow rate in point 3 in kg/s</p>
<p>Column 9: Mass flow rate in point 4 in kg/s</p>
<p>Column 10: Outdoor temperature in K</p>

<p><b><span style=\"color: #008000;\">Test procedure</span></b> </p>
Information at several points of the district heating network is recorded during a week.

<p><b><span style=\"color: #008000;\">Test bench schematic</span></b> </p>
<p><img alt=\"Schematic of test district heating network in Pongau\" src=\"modelica://Buildings/Resources/Images/Fluid/FixedResistances/Validation/PlugFlowPipes/AITTestBench.png\" border=\"1\"/>
</p>

<p>
Notice that length are approximated
</p>

<p><b><span style=\"color: #008000;\">Pipe characteristics</span></b> </p>
<ul>
<li>Inner diameter: 0.0825 m (DN080)</li>
<li>Outer diameter: 0.0889 m (stell wall thickness 3.2 mm)</li>
<li>Casing diameter: 0.18 m </li>
<li>Insulation material: Polyurethane </li>
<li>Heat conductivity of insulation material: 0.024 W/(m K) (average value at 50 °C) </li>
<li>Length specific pipe's heat loss coefficient: 0.208 W/(m K) </li>
<li>Wall roughness coefficient: 0.1 mm </li>
</ul>

</html>"));
end PipeDataAIT151218;
