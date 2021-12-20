within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
model SampleTrigger
  "Validation model for the SampleTrigger block"
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    period=0.5)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp(
    duration=5,
    offset=0,
    height=20)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler
    "Triggered sampler"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri1(
    period=0.5,
    shift=1.3)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler1
    "Triggered sampler"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

equation
  connect(ramp.y,triggeredSampler.u)
    annotation (Line(points={{-58,70},{18,70}},color={0,0,127}));
  connect(samTri.y,triggeredSampler.trigger)
    annotation (Line(points={{-8,30},{30,30},{30,58.2}},color={255,0,255}));
  connect(samTri1.y,triggeredSampler1.trigger)
    annotation (Line(points={{-8,-70},{30,-70},{30,-41.8}},color={255,0,255}));
  connect(triggeredSampler1.u,ramp.y)
    annotation (Line(points={{18,-30},{-40,-30},{-40,70},{-58,70}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=5.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/SampleTrigger.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger\">
Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger</a>.
The instances <code>samTri</code> and <code>samTri1</code> use a different value for the parameter <code>shift</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
December 03, 2020, by Milica Grahovac:<br/>
Added a test case with a <code>shift</code> parameter set to a value larger than zero.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2282\">#2282</a>.
</li>
<li>
July 17, 2017, by Jianjun Hu:<br/>
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
end SampleTrigger;
