within Buildings.Controls.OBC.CDL.Discrete.Examples;
model TriggeredSampler "Example model for the TriggeredSampler block"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=6.2831852) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=0.2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "Triggered sampler wity y_start = 0"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(y_start=1)
    "Triggered sampler with y_start = 1"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-39,0},{-22,0}},         color={0,0,127}));
  connect(sin1.y, triSam.u)
    annotation (Line(points={{1,0},{38,0}}, color={0,0,127}));
  connect(booPul.y, triSam.trigger) annotation (Line(points={{11,-40},{50,-40},
          {50,-12},{50,-11.8}}, color={255,0,255}));
  connect(sin1.y, triSam1.u)
    annotation (Line(points={{1,0},{30,0},{30,50},{58,50}}, color={0,0,127}));
  connect(booPul.y, triSam1.trigger)
    annotation (Line(points={{11,-40},{70,-40},{70,38.2}}, color={255,0,255}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Discrete/Examples/TriggeredSampler.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler\">
Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler</a>.
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
end TriggeredSampler;
