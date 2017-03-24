within Buildings.Experimental.OpenBuildingControl.CDL.Sources;
block BooleanPulse "Generate pulse signal of type Boolean"

  parameter Real width(
    final min=Modelica.Constants.small,
    final max=100) = 50 "Width of pulse in % of period";
  parameter Modelica.SIunits.Time period(final min=Modelica.Constants.small,
      start=1) "Time for one period";
  parameter Modelica.SIunits.Time startTime=0 "Time instant of first pulse";
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time Twidth=period*width/100
    "width of one pulse" annotation (HideResult=true);
  discrete Modelica.SIunits.Time pulsStart "Start time of pulse"
    annotation (HideResult=true);
initial equation
  pulsStart = startTime;
equation
  when sample(startTime, period) then
    pulsStart = time;
  end when;
  y = time >= pulsStart and time < pulsStart + Twidth;
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),     Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%period"), Line(points={{-80,-70},{-40,-70},{-40,44},{0,
              44},{0,-70},{40,-70},{40,44},{79,44}}),
        Polygon(
          points={{-80,88},{-88,66},{-72,66},{-80,88}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,66},{-80,-82}}, color={255,0,255}),
        Line(points={{-90,-70},{72,-70}}, color={255,0,255}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-60,-74},{-19,-82}},
          lineColor={0,0,0},
          textString="startTime"),
        Line(
          points={{-78,-70},{-40,-70},{-40,20},{20,20},{20,-70},{50,-70},{50,
              20},{100,20}},
          color={0,0,255},
          thickness=0.5),
        Line(points={{-40,61},{-40,21}}, color={95,95,95}),
        Line(points={{20,44},{20,20}}, color={95,95,95}),
        Line(points={{50,58},{50,20}}, color={95,95,95}),
        Line(points={{-40,53},{50,53}}, color={95,95,95}),
        Line(points={{-40,35},{20,35}}, color={95,95,95}),
        Text(
          extent={{-30,65},{16,55}},
          lineColor={0,0,0},
          textString="period"),
        Text(
          extent={{-33,47},{14,37}},
          lineColor={0,0,0},
          textString="width"),
        Line(points={{-70,20},{-41,20}}, color={95,95,95}),
        Polygon(
          points={{-40,35},{-31,37},{-31,33},{-40,35}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,35},{12,37},{12,33},{20,35}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-40,53},{-31,55},{-31,51},{-40,53}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{50,53},{42,55},{42,51},{50,53}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-95,26},{-66,17}},
          lineColor={0,0,0},
          textString="true"),
        Text(
          extent={{-96,-60},{-75,-69}},
          lineColor={0,0,0},
          textString="false")}),
      Documentation(info="<html>
<p>
The Boolean output y is a pulse signal:
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
end BooleanPulse;
