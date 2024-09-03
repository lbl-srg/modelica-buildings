within Buildings.Fluid.CHPs.BaseClasses.Interfaces;
connector ModeTypeOutput = output CHPs.BaseClasses.Types.Mode
  "Output connector for mode type"
annotation (
  defaultComponentName="y",
  Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid,
      points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
    Text(
      textColor={0,0,127},
      extent={{30.0,60.0},{30.0,110.0}},
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
