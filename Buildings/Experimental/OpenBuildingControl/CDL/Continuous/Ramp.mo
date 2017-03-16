within Buildings.Experimental.OpenBuildingControl.CDL.Continuous;
block Ramp "Generate ramp signal"
  parameter Real height=1 "Height of ramps";
  parameter Modelica.SIunits.Time duration(min=0.0, start=2)
    "Duration of ramp (= 0.0 gives a Step)";
  parameter Real offset=0 "Offset of output signal";
  parameter Modelica.SIunits.Time startTime=0
    "Output = offset for time < startTime";
  extends Modelica.Blocks.Interfaces.SO;

equation
  y = offset + (if time < startTime then 0 else if time < (startTime +
    duration) then (time - startTime)*height/duration else height);
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
        Line(points={{31,38},{86,38}})}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Polygon(
          points={{-80,90},{-86,68},{-74,68},{-80,90}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={95,95,95}),
        Line(
          points={{-80,-20},{-20,-20},{50,50}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{-90,-70},{82,-70}}, color={95,95,95}),
        Polygon(
          points={{90,-70},{68,-64},{68,-76},{90,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,-20},{-42,-30},{-38,-30},{-40,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,-20},{-40,-70}},
          color={95,95,95}),
        Polygon(
          points={{-40,-70},{-42,-60},{-38,-60},{-40,-70},{-40,-70}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-72,-39},{-34,-50}},
          lineColor={0,0,0},
          textString="offset"),
        Text(
          extent={{-38,-72},{6,-83}},
          lineColor={0,0,0},
          textString="startTime"),
        Text(
          extent={{-78,92},{-37,72}},
          lineColor={0,0,0},
          textString="y"),
        Text(
          extent={{70,-80},{94,-91}},
          lineColor={0,0,0},
          textString="time"),
        Line(points={{-20,-20},{-20,-70}}, color={95,95,95}),
        Line(
          points={{-19,-20},{50,-20}},
          color={95,95,95}),
        Line(
          points={{50,50},{101,50}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{50,50},{50,-20}},
          color={95,95,95}),
        Polygon(
          points={{50,-20},{42,-18},{42,-22},{50,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-20,-20},{-11,-18},{-11,-22},{-20,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,50},{48,40},{52,40},{50,50}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,-20},{48,-10},{52,-10},{50,-20},{50,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{53,23},{82,10}},
          lineColor={0,0,0},
          textString="height"),
        Text(
          extent={{-2,-21},{37,-33}},
          lineColor={0,0,0},
          textString="duration")}),
    Documentation(info="<html>
<p>
The Real output y is a ramp signal:
</p>

<p>
<img src=\"modelica://Modelica/Resources/Images/Blocks/Sources/Ramp.png\"
     alt=\"Ramp.png\">
</p>

<p>
If parameter duration is set to 0.0, the limiting case of a Step signal is achieved.
</p>
</html>"));
end Ramp;
