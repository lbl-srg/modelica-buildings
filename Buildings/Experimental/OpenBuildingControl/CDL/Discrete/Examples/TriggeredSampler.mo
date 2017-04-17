within Buildings.Experimental.OpenBuildingControl.CDL.Discrete.Examples;
model TriggeredSampler "Example model for the TriggeredSampler block"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler triggeredSampler(
    samplePeriod = 0.2)
    "Output the triggered sampled value of a continuous signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=0,
    height=6.2831852) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc(
    cycleOn = true,
    period = 0.2)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=50) "Constant as source term"
    annotation (Placement(transformation(extent={{-60,-48},{-40,-28}})));

equation
  connect(cons1.y, dutCyc.u)
    annotation (Line(points={{-39,-38},{-26,-38},{-12,-38}}, color={0,0,127}));
  connect(dutCyc.y, triggeredSampler.trigger) annotation (Line(points={{11,-38},{26,
          -38},{26,-11.8},{40,-11.8}}, color={255,0,255}));
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}}, color={0,0,127}));
  connect(sin1.y, triggeredSampler.u)
    annotation (Line(points={{11,0},{19.5,0},{28,0}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Discrete/Examples/TriggeredSampler.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler\">
Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 31, 2017 by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TriggeredSampler;
