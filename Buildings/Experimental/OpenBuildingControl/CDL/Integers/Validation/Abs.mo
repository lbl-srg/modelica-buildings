within Buildings.Experimental.OpenBuildingControl.CDL.Integers.Validation;
model Abs "Validation model for the absolute block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Integers.Abs abs1
    "Block that outputs the absolute value of the input"
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation trunc1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));

equation
  connect(ramp1.y, trunc1.u)
    annotation (Line(points={{-51,0},{-30,0},{-30,0}}, color={0,0,127}));
  connect(trunc1.y, abs1.u)
    annotation (Line(points={{-7,0},{4,0},{14,0}}, color={255,127,0}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Integers/Validation/Abs.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Integers.Abs\">
Buildings.Experimental.OpenBuildingControl.CDL.Integers.Abs</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Abs;
