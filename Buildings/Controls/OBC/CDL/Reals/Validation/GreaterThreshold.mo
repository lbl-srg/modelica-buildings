within Buildings.Controls.OBC.CDL.Reals.Validation;
model GreaterThreshold
  "Validation model for the GreaterThreshold block"
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold gre(t=2)
    "Greater block, without hysteresis"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greHys(t=2, h=1)
    "Greater block, with hysteresis"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    amplitude=8,
    freqHz=1/10,
    offset=-2,
    startTime=1)
    "Sine source"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
equation
  connect(sin.y, gre.u)
    annotation (Line(points={{-18,30},{38,30}}, color={0,0,127}));
  connect(sin.y, greHys.u) annotation (Line(points={{-18,30},{20,30},{20,-20},{38,
          -20}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/GreaterThreshold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.GreaterThreshold\">
Buildings.Controls.OBC.CDL.Reals.GreaterThreshold</a>.
The instance <code>gre</code> has no hysteresis, and the
instance <code>greHys</code> has a hysteresis.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 14, 2023, by Jianjun Hu:<br/>
Changed the greater block input to avoid near zero crossing.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3294\">
issue 3294</a>.
</li>     
<li>
August 5, 2020, by Michael Wetter:<br/>
Updated model to add a test case with hysteresis.
</li>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end GreaterThreshold;
