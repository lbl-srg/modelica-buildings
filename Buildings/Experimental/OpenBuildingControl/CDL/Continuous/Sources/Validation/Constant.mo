within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Validation;
model Constant "Validate the Constant block"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant
    con(k=2.5) "Block output real constant value"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Sources/Validation/Constant.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant</a>.
</p>

</html>", revisions="<html>
<ul>
<li>
July 17, 2017, by Jianjun Hu:<br/>
First implemented in CDL.Continuous.Sources package.
</li>
</ul>
</html>"));
end Constant;
