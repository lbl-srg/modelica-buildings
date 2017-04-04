within Buildings.Experimental.OpenBuildingControl.CDL.Sources.Validation;
model SampleTrigger "Validation model for the SampleTrigger block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.SampleTrigger SamTri1(
    period = 0.5)
    "Block that generates sample trigger signal"
    annotation (Placement(transformation(extent={{2,-4},{22,16}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler triggeredSampler(
    samplePeriod = 0.2)
    "Output the triggered sampled value of a continuous signal"
    annotation (Placement(transformation(extent={{42,44},{62,64}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp2(
    duration=5,
    offset=0,
    height=20) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{2,44},{22,64}})));

equation
  connect(SamTri1.y, triggeredSampler.trigger) annotation (Line(points={{23,6},{
          38,6},{38,42.2},{52,42.2}}, color={255,0,255}));
  connect(ramp2.y, triggeredSampler.u)
    annotation (Line(points={{23,54},{31.5,54},{40,54}}, color={0,0,127}));
  annotation (
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
