within Buildings.Experimental.OpenBuildingControl.CDL.Sources.Validation;
model Ramp "Validation model for the Ramp"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ram(
    height = 2,
    duration = 3,
    offset=0.5,
    startTime = 1.0)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Sources/Validation/Ramp.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp\">
Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
April 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Ramp;
