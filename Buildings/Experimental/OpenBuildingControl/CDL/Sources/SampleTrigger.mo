within Buildings.Experimental.OpenBuildingControl.CDL.Sources;
block SampleTrigger "Generate sample trigger signal"
  parameter Modelica.SIunits.Time period(final min=Modelica.Constants.small,
      start=0.01) "Sample period";
  parameter Modelica.SIunits.Time startTime=0
    "Time instant of first sample trigger";
  extends Interfaces.partialBooleanSource;

equation
  y = sample(startTime, period);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-60,-70},{-60,70}}),
        Line(points={{-20,-70},{-20,70}}),
        Line(points={{20,-70},{20,70}}),
        Line(points={{60,-70},{60,70}}),
        Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%period")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-51,-72},{-11,-81}},
          lineColor={0,0,0},
          textString="startTime"),
        Line(points={{-30,47},{-30,19}}, color={95,95,95}),
        Line(points={{0,47},{0,18}}, color={95,95,95}),
        Line(points={{-30,41},{0,41}}, color={95,95,95}),
        Text(
          extent={{-37,61},{9,49}},
          lineColor={0,0,0},
          textString="period"),
        Line(points={{-73,19},{-30,19}}, color={95,95,95}),
        Polygon(
          points={{-30,41},{-21,43},{-21,39},{-30,41}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,41},{-8,43},{-8,39},{0,41}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-91,23},{-71,13}},
          lineColor={0,0,0},
          textString="true"),
        Text(
          extent={{-90,-59},{-70,-68}},
          lineColor={0,0,0},
          textString="false"),
        Line(
          points={{0,-70},{0,19}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-30,-70},{-30,19}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{30,-70},{30,19}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{60,-70},{60,19}},
          color={0,0,255},
          thickness=0.5)}),
      Documentation(info="<html>
<p>
The Boolean output y is a trigger signal where the output y is only <b>true</b>
at sample times (defined by parameter <b>period</b>) and is otherwise
<b>false</b>.
</p>

</html>", revisions="<html>
<ul>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end SampleTrigger;
