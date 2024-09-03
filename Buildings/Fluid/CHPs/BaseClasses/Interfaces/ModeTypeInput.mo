within Buildings.Fluid.CHPs.BaseClasses.Interfaces;
connector ModeTypeInput = input CHPs.BaseClasses.Types.Mode
  "Input connector for mode type"
annotation (
  defaultComponentName="u",
  Icon(graphics={
    Polygon(
      lineColor={0,127,0},
      fillColor={0,127,0},
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
      lineColor={0,127,0},
      fillColor={0,127,0},
      fillPattern=FillPattern.Solid,
      points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
    Text(
      textColor={0,0,127},
      extent={{-10.0,60.0},{-10.0,85.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with one output signal of type
<a href=\"modelica://Buildings.Fluid.CHPs.BaseClasses.Types.Mode\">
Buildings.Fluid.CHPs.BaseClasses.Types.Mode</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
