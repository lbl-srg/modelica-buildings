within Buildings.Experimental.OpenBuildingControl.CDL.SetPoints;
block Clock "Generate actual time signal"
  parameter Modelica.SIunits.Time offset=0 "Offset of output signal";
  parameter Modelica.SIunits.Time startTime=0
    "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

equation
  y = offset + (if time < startTime then 0 else time - startTime);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
        Line(points={{0,80},{0,60}}, color={160,160,164}),
        Line(points={{80,0},{60,0}}, color={160,160,164}),
        Line(points={{0,-80},{0,-60}}, color={160,160,164}),
        Line(points={{-80,0},{-60,0}}, color={160,160,164}),
        Line(points={{37,70},{26,50}}, color={160,160,164}),
        Line(points={{70,38},{49,26}}, color={160,160,164}),
        Line(points={{71,-37},{52,-27}}, color={160,160,164}),
        Line(points={{39,-70},{29,-51}}, color={160,160,164}),
        Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
        Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
        Line(points={{-71,37},{-54,28}}, color={160,160,164}),
        Line(points={{-38,70},{-28,51}}, color={160,160,164}),
        Line(
          points={{0,0},{-50,50}},
          thickness=0.5),
        Line(
          points={{0,0},{40,0}},
          thickness=0.5),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="startTime=%startTime")}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-80,90},{-85,68},{-75,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(
          points={{-80,0},{-10,0},{60,70}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
        Polygon(
          points={{90,-70},{68,-64},{68,-76},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-34,0},{-37,-13},{-31,-13},{-34,0}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-34,0},{-34,-70}},   color={95,95,95}),
        Polygon(
          points={{-34,-70},{-37,-57},{-31,-57},{-34,-70},{-34,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-77,-28},{-35,-40}},
          lineColor={0,0,0},
          textString="offset"),
        Text(
          extent={{-30,-73},{18,-86}},
          lineColor={0,0,0},
          textString="startTime"),
        Text(
          extent={{-81,91},{-40,71}},
          lineColor={0,0,0},
          textString="y"),
        Text(
          extent={{63,-79},{94,-89}},
          lineColor={0,0,0},
          textString="time"),
        Line(points={{-10,0},{-10,-70}}, color={95,95,95}),
        Line(points={{-10,0},{50,0}}, color={95,95,95}),
        Line(points={{50,0},{50,60}}, color={95,95,95}),
        Text(
          extent={{35,33},{50,23}},
          lineColor={0,0,0},
          textString="1"),
        Text(
          extent={{14,13},{32,1}},
          lineColor={0,0,0},
          textString="1")}),
    Documentation(info="<html>
<p>
The Real output y is a clock signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Clock.png\"
     alt=\"Clock.png\">
</p>
</html>"));
end Clock;
