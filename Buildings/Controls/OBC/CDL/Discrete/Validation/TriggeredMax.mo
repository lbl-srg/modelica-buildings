within Buildings.Controls.OBC.CDL.Discrete.Validation;
model TriggeredMax
  "Example model for the TriggeredMax block"
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMax triggeredMax
    "Output the maximum, absolute value of a continuous signal at trigger instants"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=6.2831852)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.5,
    period=0.2)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));

equation
  connect(ramp1.y,sin1.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}},color={0,0,127}));
  connect(sin1.y,triggeredMax.u)
    annotation (Line(points={{11,0},{19.5,0},{28,0}},color={0,0,127}));
  connect(booPul.y,triggeredMax.trigger)
    annotation (Line(points={{11,-40},{26,-40},{40,-40},{40,-11.8}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Validation/TriggeredMax.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.TriggeredMax\">
Buildings.Controls.OBC.CDL.Discrete.TriggeredMax</a>.
</p>
</html>",
      revisions="<html>
<ul>
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
end TriggeredMax;
