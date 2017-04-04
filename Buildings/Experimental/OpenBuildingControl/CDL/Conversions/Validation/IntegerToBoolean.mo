within Buildings.Experimental.OpenBuildingControl.CDL.Conversions.Validation;
model IntegerToBoolean
  "Validation model for the IntegerToBoolean block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Conversions.IntegerToBoolean InToBoo1(
    threshold=1)
    "Block that convert Integer to Boolean signal"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Truncation trunc1
    "Block that discards the fractional portion of input and provides a whol number output"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-3.5,
    height=7.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp1.y, trunc1.u)
    annotation (Line(points={{-39,0},{-12,0},{-12,0}}, color={0,0,127}));
  connect(trunc1.y, InToBoo1.u)
    annotation (Line(points={{11,0},{28,0},{28,0}}, color={255,127,0}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Conversions/Validation/IntegerToBoolean.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Conversions.IntegerToBoolean\">
Buildings.Experimental.OpenBuildingControl.CDL.Conversions.IntegerToBoolean</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end IntegerToBoolean;
