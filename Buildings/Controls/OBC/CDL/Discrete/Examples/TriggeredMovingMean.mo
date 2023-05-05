within Buildings.Controls.OBC.CDL.Discrete.Examples;
model TriggeredMovingMean
  "Validation model for the TriggeredMovingMean block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sin sin(
    freqHz=1/8,
    phase=0.5235987755983,
    startTime=-0.5)
    "Example input signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.5,
    period=1,
    shift=-0.5)
    "Block that outputs trigger signals"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea(
    n=3)
    "Triggered moving mean with 3 samples to average"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea1(
    n=1)
    "Triggered moving mean with 1 sample to average"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredMovingMean triMovMea2(
    n=3)
    "Triggered moving mean with 3 samples to average with a different trigger period"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.5,
    period=1)
    "Block that outputs trigger signals"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

equation
  connect(sin.y,triMovMea.u)
    annotation (Line(points={{-38,50},{-20,50},{-20,10},{-2,10}},color={0,0,127}));
  connect(booPul.y,triMovMea.trigger)
    annotation (Line(points={{-38,-10},{10,-10},{10,-2}},color={255,0,255}));
  connect(booPul.y,triMovMea1.trigger)
    annotation (Line(points={{-38,-10},{-10,-10},{-10,30},{10,30},{10,58}},color={255,0,255}));
  connect(sin.y,triMovMea1.u)
    annotation (Line(points={{-38,50},{-20,50},{-20,70},{-2,70}},color={0,0,127}));
  connect(booPul1.y,triMovMea2.trigger)
    annotation (Line(points={{-38,-70},{10,-70},{10,-62}},color={255,0,255}));
  connect(sin.y,triMovMea2.u)
    annotation (Line(points={{-38,50},{-20,50},{-20,-50},{-2,-50}},color={0,0,127}));
  annotation (
    experiment(
      StartTime=-0.5,
      StopTime=15.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/TriggeredMovingMean.mos" "Simulate and plot"),
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
end TriggeredMovingMean;
