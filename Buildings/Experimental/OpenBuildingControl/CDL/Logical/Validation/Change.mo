within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Change "Validation model for the Change block."
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc(
    cycleOn = true,
    period = 1.0)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-32,-8},{-12,12}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=0.5)
                                                                                 "Constant as source term"
    annotation (Placement(transformation(extent={{-72,-8},{-52,12}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Change change
    annotation (Placement(transformation(extent={{4,-8},{24,12}})));

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
  connect(cons1.y, dutCyc.u)
    annotation (Line(points={{-51,2},{-51,2},{-34,2}},    color={0,0,127}));
  connect(dutCyc.y, change.u)
    annotation (Line(points={{-11,2},{2,2}},        color={255,0,255}));
  connect(change.y, triggeredSampler.trigger) annotation (Line(points={{25,2},{
          38,2},{38,42.2},{52,42.2}}, color={255,0,255}));
  connect(ramp2.y, triggeredSampler.u)
    annotation (Line(points={{23,54},{40,54},{40,54}}, color={0,0,127}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Change.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Change\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Change</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Change;
