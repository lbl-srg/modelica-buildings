within Buildings.Experimental.OpenBuildingControl.CDL.Interfaces;
connector StatusTypeInput = input Types.Status
                      "fixme Input connector for a value of type Status." annotation (
  defaultComponentName="u",
  Icon(graphics={
    Polygon(
      lineColor={255,85,85},
      fillColor={255,85,85},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})},
    coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
      preserveAspectRatio=true,
      initialScale=0.2)),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      initialScale=0.2,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={255,85,85},
      fillColor={255,85,85},
      fillPattern=FillPattern.Solid,
      points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
    Text(
      lineColor={255,85,85},
      extent={{-10.0,60.0},{-10.0,85.0}},
      textString="%name",
        fillColor={255,85,85},
        fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>", revisions="<html>
<ul>
<li>
January 6, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
