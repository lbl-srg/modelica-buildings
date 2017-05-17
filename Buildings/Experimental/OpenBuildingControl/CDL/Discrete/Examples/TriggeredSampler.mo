within Buildings.Experimental.OpenBuildingControl.CDL.Discrete.Examples;
model TriggeredSampler "Example model for the TriggeredSampler block"

  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=6.2831852) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul(
    width = 0.5,
    period = 0.2)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler
    triggeredSampler
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}}, color={0,0,127}));
  connect(sin1.y, triggeredSampler.u)
    annotation (Line(points={{11,0},{38,0}}, color={0,0,127}));
  connect(booPul.y, triggeredSampler.trigger) annotation (Line(points={{11,-40},
          {50,-40},{50,-12},{50,-11.8}}, color={255,0,255}));
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
