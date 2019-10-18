within Buildings.Controls.OBC.CDL.Discrete.Examples;
model TriggeredMovingMean "Validation model for the TriggeredMovingMean block"
  Continuous.Sources.Sine sin(
    freqHz=1/8,
    phase=0.5235987755983,
    startTime=-0.5) "Example input signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea(n=4,
      samplePeriod=1) "Triggered moving mean"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Logical.Sources.Pulse booPul(
    width=0.5,
    period=6,
    startTime=-0.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation

  connect(sin.y, triMovMea.u)
    annotation (Line(points={{-38,10},{-2,10}}, color={0,0,127}));
  connect(booPul.y, triMovMea.trigger) annotation (Line(points={{-38,-30},{10,-30},
          {10,-1.8}}, color={255,0,255}));
  annotation (
  experiment(StartTime=-0.5, StopTime=15.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/TriggeredMovingMean.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean\">
Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 16, 2019 by Kun Zhang:<br/>
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
end TriggeredMovingMean;
