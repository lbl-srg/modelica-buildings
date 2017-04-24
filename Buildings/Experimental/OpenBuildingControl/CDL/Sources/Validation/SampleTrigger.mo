within Buildings.Experimental.OpenBuildingControl.CDL.Sources.Validation;
model SampleTrigger "Validation model for the SampleTrigger block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.SampleTrigger samTri(
    period = 0.5)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler triggeredSampler(
    samplePeriod = 0.2)
    "Output the triggered sampled value of a continuous signal"
    annotation (Placement(transformation(extent={{10,10},{30,30}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp2(
    duration=5,
    offset=0,
    height=20) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

equation
  connect(samTri.y, triggeredSampler.trigger) annotation (Line(points={{-9,-20},
          {20,-20},{20,8.2}},         color={255,0,255}));
  connect(ramp2.y, triggeredSampler.u)
    annotation (Line(points={{-9,20},{1.5,20},{8,20}},   color={0,0,127}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Sources/Validation/SampleTrigger.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Sources.SampleTrigger\">
Buildings.Experimental.OpenBuildingControl.CDL.Sources.SampleTrigger</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
April 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SampleTrigger;
