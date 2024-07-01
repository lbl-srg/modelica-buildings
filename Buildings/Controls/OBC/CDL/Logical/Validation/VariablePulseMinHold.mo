within Buildings.Controls.OBC.CDL.Logical.Validation;
model VariablePulseMinHold
  "Validation model for producing boolean pulse output"

  Buildings.Controls.OBC.CDL.Logical.VariablePulse conChaWid(
    period=3,
    minTruFalHol=1)
    "Variable pulse with constantly changing pulse width "
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse conPul1(
    amplitude=0.4,
    width=0.4,
    period=4,
    shift=1.6,
    offset=0.5)
    "Continuous pulse signal"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
equation
  connect(conPul1.y, conChaWid.u)
    annotation (Line(points={{-8,0},{8,0}}, color={0,0,127}));
annotation (experiment(
      StopTime=5,
      Tolerance=1e-06),
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/VariablePulseMinHold.mos" "Simulate and plot"),
  Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.VariablePulse\">
Buildings.Controls.OBC.CDL.Logical.VariablePulse</a>.
</p>
<p>
It tests the case that the input value changes at the moment when the output
is still in previous status in less than the minimum holding time.
In the case, the output holds the previous status for the minimum holding time
and then change to the new status.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 11, 2022, by Jianjun Hu:<br/>
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
end VariablePulseMinHold;
