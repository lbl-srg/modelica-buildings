within Buildings.Obsolete.Controls.OBC.CDL.Continuous.Validation;
model Feedback "Validation model for the Feedback block"
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.Feedback feedback1
    "Block that outputs difference between commanded and feedback input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-1,
    height=4)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    height=2,
    duration=1,
    offset=-1)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(ramp1.y,feedback1.u1)
    annotation (Line(points={{-38,0},{-12,0}},color={0,0,127}));
  connect(ramp2.y,feedback1.u2)
    annotation (Line(points={{-38,-30},{0,-30},{0,-12}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Continuous/Validation/Feedback.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Continuous.Feedback\">
Buildings.Obsolete.Controls.OBC.CDL.Continuous.Feedback</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, input <code>u2</code> varies from <i>-1</i> to <i>+1</i>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 20, 2017, by Jianjun Hu:<br/>
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
end Feedback;
