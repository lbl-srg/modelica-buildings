within Buildings.Controls.OBC.CDL.Discrete.Examples;
model MovingMean "Validation model for the MovingMean block"
  Continuous.Sources.Sine sin(
    freqHz=1/8,
    phase=0.5235987755983,
    startTime=-0.5) "Example input signal"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Discrete.MovingMean movMea(
    n=4,
    samplePeriod=1,
    startTime=-0.5,
    use_trigger=false)
    "Discrete moving mean of the sampled input signal"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Discrete.MovingMean triMovMea(
    n=4,
    samplePeriod=1,
    startTime=-0.5)
    "Triggered discrete moving mean of the sampled input signal"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Logical.Sources.Pulse booPul(
    width=0.5,
    period=6,
    startTime=-0.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam(samplePeriod=1)
    "Sampling the input"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
equation
  connect(sin.y, movMea.u) annotation (Line(points={{-38,10},{-2,10}}, color={0,0,127}));
  connect(sin.y, triMovMea.u) annotation (Line(points={{-38,10},{-20,10},{-20,-30},
          {-2,-30}}, color={0,0,127}));
  connect(booPul.y, triMovMea.trigger) annotation (Line(points={{-38,-50},{10,-50},
          {10,-41.8}}, color={255,0,255}));
  connect(sin.y, sam.u) annotation (Line(points={{-38,10},{-20,10},{-20,50},{-2,
          50}}, color={0,0,127}));
  annotation (
  experiment(StartTime=-0.5, StopTime=15.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/MovingMean.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
Validation tests for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.MovingMean\">
Buildings.Controls.OBC.CDL.Discrete.MovingMean</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 15, 2019 by Kun Zhang:<br/>
Added a test case for the triggered moving mean.
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
