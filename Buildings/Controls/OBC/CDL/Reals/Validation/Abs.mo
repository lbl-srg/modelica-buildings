within Buildings.Controls.OBC.CDL.Reals.Validation;
model Abs
  "Validation model for the absolute block"
  Buildings.Controls.OBC.CDL.Reals.Abs abs1
    "Block that outputs the absolute value of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp(
    height=2,
    duration=1,
    offset=-1)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp.y,abs1.u)
    annotation (Line(points={{-38,0},{-38,0},{-12,0}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Abs.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Abs\">
Buildings.Controls.OBC.CDL.Reals.Abs</a>.
The input varies from <i>-1</i> to <i>+1</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 17, 2017, by Jianjun Hu:<br/>
Update the Ramp block: <a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Ramp\">
Buildings.Controls.OBC.CDL.Reals.Ramp</a>.
</li>
</ul>
<ul>
<li>
February 22, 2017, by Michael Wetter:<br/>
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
end Abs;
