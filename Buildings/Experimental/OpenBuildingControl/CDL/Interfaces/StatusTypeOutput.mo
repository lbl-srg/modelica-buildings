within Buildings.Experimental.OpenBuildingControl.CDL.Interfaces;
connector StatusTypeOutput =
                         output Types.Status
  "fixme Outputs a value of type Status."
annotation (
  defaultComponentName="y",
  Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={255,85,85},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={255,85,85},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
    Text(
      lineColor={255,85,85},
      extent={{30.0,60.0},{30.0,110.0}},
      textString="%name",
        fillColor={255,85,85},
        fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
  <p>
Connector with one output signal of type
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Types.Day\">
Buildings.Experimental.OpenBuildingControl.CDL.Types.Day</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 11, 2017, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
