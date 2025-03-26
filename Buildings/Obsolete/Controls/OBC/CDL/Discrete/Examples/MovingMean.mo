within Buildings.Obsolete.Controls.OBC.CDL.Discrete.Examples;
model MovingMean "Validation model for the MovingMean block"
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    freqHz=1/8,
    phase=0.5235987755983,
    startTime=-0.5) "Example input signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Obsolete.Controls.OBC.CDL.Discrete.MovingMean movMea(n=4, samplePeriod=1)
      "Discrete moving mean of the sampled input signal"
  annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
connect(sin.y, movMea.u)
  annotation (Line(points={{-38,10},{-2,10}}, color={0,0,127}));

  annotation (
  experiment(StartTime=-0.5, StopTime=15.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Discrete/Examples/MovingMean.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Discrete.MovingMean\">
Buildings.Obsolete.Controls.OBC.CDL.Discrete.MovingMean</a>.
</p>
</html>",
revisions=
"<html>
<ul>
<li>
November 12, 2019, by Kun Zhang:<br/>
Moved model to
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Discrete.Examples\">Buildings.Obsolete.Controls.OBC.CDL.Discrete.Examples</a>
because the block <a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.MovingMean\">
Buildings.Controls.OBC.CDL.Discrete.MovingMean</a> was moved to
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean\">
Buildings.Obsolete.Controls.OBC.CDL.Discrete.MovingMean</a>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1588\">issue 1588</a>.
</li>
<li>
June 17, 2019 by Kun Zhang:<br/>
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
end MovingMean;
