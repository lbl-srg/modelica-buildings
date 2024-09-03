within Buildings.ThermalZones.EnergyPlus_9_6_0.Types;
type LogLevels = enumeration(
    Error
  "Errors",
    Warning
  "Warnings",
    Info
  "Information",
    Verbose
  "Verbose, log calls in initialization and shut-down",
    Debug
  "Verbose, log everything at each time step")
  "Enumeration for logging"
  annotation (Documentation(info="<html>
<p>
Enumeration for the level of outputs written by EnergyPlus.
The possible values are:
</p>
<table summary=\"log levels\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr><th>LogLevels</th><th>Explanation</th></tr>
<tr><td>Error</td><td>Logs EnergyPlus errors and fatal errors.</td></tr>
<tr><td>Warning</td><td>Logs in addition EnergyPlus warnings.</td></tr>
<tr><td>Info</td><td>Logs in addition EnergyPlus informational messages.</td></tr>
<tr><td>Verbose</td><td>Logs in addition main C function calls during initialization and shut-down.</td></tr>
<tr><td>Debug</td><td>Logs everything, including all calls during time steps which can give large log files.</td></tr>
</table>
</html>",revisions="<html>
<ul>
<li>
July 23, 2020, by Michael Wetter:<br/>
Revised implementation to combine errors and fatal errors, as they should both be reported always.
</li>
<li>
September 25, 2019, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 21, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(
    graphics={Rectangle(
      lineColor={200,200,200},
      fillColor={248,248,248},
      fillPattern=FillPattern.HorizontalCylinder,
      extent={{-100,-100},{100,100}},radius=25.0),
      Polygon(points={{0,76},{-80,-64},{80,-64},{0,76}},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,pattern=LinePattern.None,lineColor={0,0,0}),
      Polygon(points={{0,68},{-72,-60},{72,-60},{0,68}},lineColor={0,0,0},
      fillColor={255,255,170},fillPattern=FillPattern.Solid),
      Ellipse(extent={{-6,-36},{4,-46}},pattern=LinePattern.None,
      fillColor={0,0,0},fillPattern=FillPattern.Solid),
      Rectangle(extent={{-4,34},{2,-28}},fillColor={0,0,0},fillPattern=FillPattern.Solid,
      pattern=LinePattern.None)}));
