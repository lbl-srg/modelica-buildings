within Buildings.Controls.OBC.CDL.Logical.Sources;
block Pulse "Generate pulse signal of type Boolean"

  parameter Real width(
    final min=Constants.small,
    final max=1,
    final unit = "1") = 0.5 "Width of pulse in fraction of period";
  parameter Modelica.SIunits.Time period(
    final min=Constants.small) "Time for one period";
  parameter Modelica.SIunits.Time startTime=0 "Time instant of first pulse";
  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Time Twidth=period*width
    "Width of one pulse";
  discrete Modelica.SIunits.Time pulseStart "Start time of pulse";

initial equation
  pulseStart = startTime;
equation
  when sample(startTime, period) then
    pulseStart = time;
  end when;
  y = time >= pulseStart and time < pulseStart + Twidth;
  annotation (
    defaultComponentName="booPul",
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
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name")}),
      Documentation(info="<html>
<p>
The Boolean output y is a pulse signal:
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Logical/Sources/BooleanPulse.png\"
     alt=\"BooleanPulse.png\" />
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
end Pulse;
