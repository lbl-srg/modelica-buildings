within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Hysteresis "Validation model for the Hysteresis block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=6.2831852) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-32,-10},{-12,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gain1(
    k = 2.5)
    "Block that outputs the product of a gain value with the input signal"
    annotation (Placement(transformation(extent={{8,-10},{28,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis1(
    uLow = 0,
    uHigh = 1) "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{48,-10},{68,10}})));

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-55,0},{-34,0},{-34,0}}, color={0,0,127}));
  connect(sin1.y, gain1.u)
    annotation (Line(points={{-11,0},{-2,0},{6,0}}, color={0,0,127}));
  connect(gain1.y, hysteresis1.u)
    annotation (Line(points={{29,0},{38,0},{46,0}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Hysteresis.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Hysteresis\">
Buildings.Controls.OBC.CDL.Continuous.Hysteresis</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Hysteresis;
