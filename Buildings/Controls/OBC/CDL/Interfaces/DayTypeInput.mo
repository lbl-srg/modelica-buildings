within Buildings.Controls.OBC.CDL.Interfaces;
connector DayTypeInput = input Types.Day "Input connector for day types"
annotation (
  defaultComponentName="u",
  Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,0},
      fillColor={0,127,0},
      fillPattern=FillPattern.Solid,
      points={{-100.0,100.0},{100.0,0.0},{-100.0,-100.0}})}),
  Diagram(
    coordinateSystem(preserveAspectRatio=true,
      initialScale=0.2,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,0},
      fillColor={0,127,0},
      fillPattern=FillPattern.Solid,
      points={{0,50},{100,0},{0,-50}}),
    Text(
      lineColor={0,127,0},
      extent={{-10.0,60.0},{-10.0,85.0}},
      textString="%name")}),
  Documentation(info="<html>
<p>
Connector with one input signal of type
<a href=\"modelica://Buildings.Controls.OBC.CDL.Types.Day\">
Buildings.Controls.OBC.CDL.Types.Day</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
