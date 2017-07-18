within Buildings.Experimental.OpenBuildingControl.CDL.Integers.Validation;
model Add3 "Validation model for the Add3 block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Integers.Add3 add1
    "Block that outputs the sum of the three inputs"
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation truncation1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-28,26},{-8,46}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-72,26},{-52,46}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation truncation2
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-0.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation truncation3
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-28,-46},{-8,-26}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Ramp ramp3(
    duration=1,
    offset=-1.5,
    height=9.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-72,-46},{-52,-26}})));

equation
  connect(ramp1.y, truncation1.u)
    annotation (Line(points={{-51,36},{-46,36},{-30,36}}, color={0,0,127}));
  connect(ramp2.y, truncation2.u) annotation (Line(points={{-51,0},{-40.5,0},{-30,0}},
                 color={0,0,127}));
  connect(truncation1.y, add1.u1)
    annotation (Line(points={{-7,36},{2,36},{2,8},{14,8}}, color={255,127,0}));
  connect(truncation2.y, add1.u2) annotation (Line(points={{-7,0},{2,0},{14,0}},
                color={255,127,0}));
  connect(ramp3.y, truncation3.u)
    annotation (Line(points={{-51,-36},{-40,-36},{-30,-36}}, color={0,0,127}));
  connect(truncation3.y, add1.u3) annotation (Line(points={{-7,-36},{2,-36},{2,-8},{14,
          -8}}, color={255,127,0}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Integers/Validation/Add3.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Integers.Add3\">
Buildings.Experimental.OpenBuildingControl.CDL.Integers.Add3</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Add3;
