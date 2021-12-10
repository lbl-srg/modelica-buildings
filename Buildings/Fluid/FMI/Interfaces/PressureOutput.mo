within Buildings.Fluid.FMI.Interfaces;
connector PressureOutput =
  output Modelica.Units.SI.AbsolutePressure (
                                           displayUnit="Pa")
  "Connector for pressure output"
  annotation (
  defaultComponentName="p",
  Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
    Text(
      textColor={0,127,127},
      extent={{30.0,60.0},{30.0,110.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with one output signal of type <code>Modelica.Units.SI.AbsolutePressure</code>.
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
