within Buildings.Controls.OBC.CDL.Interfaces;
connector DayTypeInput = input Types.Day "Input connector for day types"
annotation (
  defaultComponentName="u",
  Icon(
    coordinateSystem(preserveAspectRatio=true,
      initialScale=0.2,
      extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
    Polygon(
      lineColor={0,127,0},
      fillColor={0,127,0},
      fillPattern=FillPattern.Solid,
      points={{0,50},{100,0},{0,-50}})}),
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
March 1, 2019, by Michael Wetter:<br/>
On the icon layer, changed connector size and added the connector name.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1375\">issue 1375</a>.
</li>
<li>
July 17, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
