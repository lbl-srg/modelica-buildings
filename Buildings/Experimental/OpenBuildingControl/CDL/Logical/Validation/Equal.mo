within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Equal "Validation model for the Equal block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=5,
    offset=-2,
    height=6)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-50,8},{-30,28}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp2(
    duration=5,
    offset=-3,
    height=8) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal equal1
    annotation (Placement(transformation(extent={{2,-8},{22,12}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Discrete.TriggeredSampler triggeredSampler(
    samplePeriod = 0.2)
    "Output the triggered sampled value of a continuous signal"
    annotation (Placement(transformation(extent={{42,44},{62,64}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp3(
    duration=5,
    offset=0,
    height=20) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{2,44},{22,64}})));

equation
  connect(ramp1.y, equal1.u1)
    annotation (Line(points={{-29,18},{-16,18},{-16,2},{0,2}},
                                                           color={0,0,127}));
  connect(ramp2.y, equal1.u2) annotation (Line(points={{-29,-20},{-16,-20},{-16,
          -6},{0,-6}},
                    color={0,0,127}));
  connect(equal1.y, triggeredSampler.trigger) annotation (Line(points={{23,2},{38,
          2},{38,42.2},{52,42.2}}, color={255,0,255}));
  connect(ramp3.y, triggeredSampler.u)
    annotation (Line(points={{23,54},{31.5,54},{40,54}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Equal.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Equal</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Equal;
