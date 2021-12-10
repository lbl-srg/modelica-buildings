within Buildings.Fluid.FMI.Interfaces;
connector PressureInput =
  input Modelica.Units.SI.AbsolutePressure (
                                          displayUnit="Pa")
  "Connector for pressure input"
  annotation (
  defaultComponentName="p",
  Icon(graphics={
    Polygon(
        lineColor={0,127,127},
        fillColor={0,127,127},
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
      lineColor={0,127,127},
      fillColor={0,127,127},
      fillPattern=FillPattern.Solid,
      points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
    Text(
      textColor={0,127,127},
      extent={{-10.0,60.0},{-10.0,85.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with one input signal of type <code>Modelica.Units.SI.AbsolutePressure</code>.
This connector has been implemented to conditionally remove
the pressure if no pressure drop calculation is requested.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29,2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
