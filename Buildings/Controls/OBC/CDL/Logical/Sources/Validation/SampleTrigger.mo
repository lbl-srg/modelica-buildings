within Buildings.Controls.OBC.CDL.Logical.Sources.Validation;
model SampleTrigger "Validation model for the SampleTrigger block"

  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(
    period = 0.5)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=5,
    offset=0,
    height=20) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triggeredSampler
    "Triggered sampler"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
equation
  connect(ramp2.y, triggeredSampler.u)
    annotation (Line(points={{-9,20},{18,20}}, color={0,0,127}));
  connect(samTri.y, triggeredSampler.trigger) annotation (Line(points={{-9,-20},
          {30,-20},{30,8},{30,8.2}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Logical/Sources/Validation/SampleTrigger.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger\">
Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
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
end SampleTrigger;
