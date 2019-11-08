within Buildings.Experimental.EnergyPlus.Types;
type Verbosity = enumeration(
    Fatal "Fatal errors",
    Error "Errors",
    Warning "Warnings",
    Info "Information",
    Verbose "Verbose, including calls in initialization and shut-down",
    Debug "Output at each time step") "Enumeration for the day types" annotation (
    Documentation(info="<html>
<p>
Enumeration for the level of outputs written by EnergyPlus.
The possible values are:
</p>
<ol>
<li>
Fatal
</li>
<li>
Error
</li>
<li>
Warning
</li>
<li>
Info
</li>
<li>
Verbose
</li>
<li>
Debug
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
September 25, 2019, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
August 21, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(
          points={{0,76},{-80,-64},{80,-64},{0,76}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{0,68},{-72,-60},{72,-60},{0,68}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-6,-36},{4,-46}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,34},{2,-28}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}));
