within Buildings.Controls.OBC.CDL.Discrete.Validation;
model UnitDelay
  "Example model for the UnitDelay block"
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay unitDelay1(
    samplePeriod=0.2)
    "Sample period of component"
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

equation
  connect(ramp1.y,sin1.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}},color={0,0,127}));
  connect(sin1.y,unitDelay1.u)
    annotation (Line(points={{11,0},{20,0},{28,0}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/UnitDelay.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.UnitDelay\">
Buildings.Controls.OBC.CDL.Discrete.UnitDelay</a>.
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
end UnitDelay;
