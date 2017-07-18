within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Validation;
model Constant "Validate the Constant block"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Constant
    con(k=true) "Block output boolean constant value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Sources/Validation/Constant.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Constant\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Constant</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Constant;
