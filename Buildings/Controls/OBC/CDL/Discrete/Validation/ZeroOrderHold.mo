within Buildings.Controls.OBC.CDL.Discrete.Validation;
model ZeroOrderHold
  "Example model for the ZeroOrderHold block"
  Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold zerOrdHol(
    samplePeriod=0.2)
    "Output the input signal with a zero order hold"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=6.2831852)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Cos cos1
    "Block that outputs the cosine of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(ramp1.y,cos1.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}},color={0,0,127}));
  connect(cos1.y,zerOrdHol.u)
    annotation (Line(points={{11,0},{20,0},{28,0}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Validation/ZeroOrderHold.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold\">
Buildings.Controls.OBC.CDL.Discrete.ZeroOrderHold</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
September 14, 2017, by Michael Wetter:<br/>
Changed example to have non-zero initial conditions.
</li>
<li>
March 31, 2017 by Jianjun Hu:<br/>
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
end ZeroOrderHold;
