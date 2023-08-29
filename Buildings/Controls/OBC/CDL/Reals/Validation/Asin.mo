within Buildings.Controls.OBC.CDL.Reals.Validation;
model Asin "Validation model for the Asin block"
  Buildings.Controls.OBC.CDL.Reals.Asin arcSin
    "Block that outputs the arc tangent of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=-1,
    height=2)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp1.y, arcSin.u)
    annotation (Line(points={{-38,0},{-12,0},{-12,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Asin.mos" "Simulate and plot"),
Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Asin\">
Buildings.Controls.OBC.CDL.Reals.Asin</a>.
</p>
<p>
The input <code>u</code> varies from <i>-1</i> to <i>+1</i>.
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
end Asin;
