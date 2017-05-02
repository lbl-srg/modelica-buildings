within Buildings.Experimental.OpenBuildingControl.CDL.Sources.Validation;
model BooleanPulse "Validation model for the BooleanPulse block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul(
    width = 0.5,
    period = 1)
    "Block that generates pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Sources/Validation/BooleanPulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse\">
Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
April 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end BooleanPulse;
