within Buildings.Controls.OBC.CDL.Logical.Validation;
model ZeroCrossing
  "Validation model for the zero crossing block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=5,
    offset=0,
    height=31.415926)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-38,-10},{-18,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    width=0.15,
    period=5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-38,-44},{-18,-24}})));
  Buildings.Controls.OBC.CDL.Logical.ZeroCrossing zeroCrossing
    "Zero crossing block"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=5,
    offset=0,
    height=31.415926)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler
    "Triggered sampler"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

equation
  connect(booPul1.y,zeroCrossing.enable)
    annotation (Line(points={{-17,-34},{10,-34},{10,-12}},color={255,0,255}));
  connect(ramp1.y,sin1.u)
    annotation (Line(points={{-61,0},{-50.5,0},{-40,0}},color={0,0,127}));
  connect(sin1.y,zeroCrossing.u)
    annotation (Line(points={{-17,0},{-2,0}},color={0,0,127}));
  connect(ramp2.y,triggeredSampler.u)
    annotation (Line(points={{21,50},{58,50},{58,50}},color={0,0,127}));
  connect(zeroCrossing.y,triggeredSampler.trigger)
    annotation (Line(points={{21,0},{70,0},{70,36},{70,38},{70,38},{70,38.2}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Validation/ZeroCrossing.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.ZeroCrossing\">
Buildings.Controls.OBC.CDL.Logical.ZeroCrossing</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
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
end ZeroCrossing;
