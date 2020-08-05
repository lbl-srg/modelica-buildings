within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Hysteresis "Validation model for the Hysteresis block"

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis(
    final uLow=0,
    final uHigh=1)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis1(
    final uLow=0,
    final uHigh=1,
    final pre_y_start=true)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysteresis2(
    final uLow=0 + 0.01,
    final uHigh=1 - 0.01)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    final duration=1,
    final offset=0,
    final height=6.2831852)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-30,30},{-10,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gain1(
    final k = 2.5)
    "Block that outputs the product of a gain value with the input signal"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    final amplitude=1,
    final period=0.1)
    "Pulse signal"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul1(
    final amplitude=1,
    final period=0.1)
    "Pulse signal"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-52,40},{-32,40}}, color={0,0,127}));
  connect(sin1.y, gain1.u)
    annotation (Line(points={{-8,40},{8,40}}, color={0,0,127}));
  connect(gain1.y, hysteresis.u)
    annotation (Line(points={{32,40},{48,40}}, color={0,0,127}));
  connect(hysteresis2.u, pul1.y)
    annotation (Line(points={{18,-40},{-18,-40}}, color={0,0,127}));
  connect(pul.y, hysteresis1.u)
    annotation (Line(points={{-18,0},{18,0}}, color={0,0,127}));
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
