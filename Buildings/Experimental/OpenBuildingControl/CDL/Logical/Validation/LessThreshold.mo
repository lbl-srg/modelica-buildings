within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model LessThreshold "Validation model for the LessThreshold block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.LessEqualThreshold lessThr1
    annotation (Placement(transformation(extent={{16,-10},{36,10}})));

equation
  connect(ramp1.y, lessThr1.u)
    annotation (Line(points={{-15,0},{0,0},{14,0}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/LessThreshold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.LessThreshold\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.LessThreshold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end LessThreshold;
