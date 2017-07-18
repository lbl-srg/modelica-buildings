within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Validation;
model Pulse "Validation model for the Boolean Pulse block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Pulse booPul(
    width = 0.5,
    period = 1)
    "Block that generates pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Sources/Validation/Pulse.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Pulse\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Pulse</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implemented in CDL.Logical.Sources package.
</li>
</ul>
</html>"));
end Pulse;
