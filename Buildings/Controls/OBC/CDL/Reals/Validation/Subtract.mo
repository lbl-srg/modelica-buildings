within Buildings.Controls.OBC.CDL.Reals.Validation;
model Subtract "Validation model for the Subtract block"
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    "Block that outputs the difference of the two inputs"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp2(
    height=2,
    duration=1,
    offset=-0.5)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  connect(ramp1.y, sub.u1) annotation (Line(points={{-38,20},{-26,20},{-26,6},{-12,
          6}}, color={0,0,127}));
  connect(ramp2.y, sub.u2) annotation (Line(points={{-38,-20},{-26,-20},{-26,-6},
          {-12,-6}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Subtract.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Subtract\">
Buildings.Controls.OBC.CDL.Reals.Subtract</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, input <code>u2</code> varies from <i>-1</i> to <i>+1</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 28, 2022, by Jianjun Hu:<br/>
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
end Subtract;
