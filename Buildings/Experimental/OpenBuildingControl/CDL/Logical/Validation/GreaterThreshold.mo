within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model GreaterThreshold
  "Validation model for the GreaterThreshold block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp2(
    duration=1,
    offset=-1,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,-8},{-6,12}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.GreaterThreshold grterThr1
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(ramp2.y, grterThr1.u)
    annotation (Line(points={{-5,2},{8,2},{24,2}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/GreaterThreshold.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.GreaterThreshold\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.GreaterThreshold</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end GreaterThreshold;
