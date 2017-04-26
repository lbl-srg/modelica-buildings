within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Nand "Validation model for the Nand block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul1(
    width = 0.5,
    period = 1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,8},{-6,28}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Sources.BooleanPulse booPul2(
     width = 0.5,
     period = 5)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-26,-26},{-6,-6}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Nand nand1
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(booPul2.y, nand1.u2) annotation (Line(points={{-5,-16},{8,-16},{8,-6},
          {24,-6}}, color={255,0,255}));
  connect(booPul1.y, nand1.u1) annotation (Line(points={{-5,18},{10,18},{10,2},{
          24,2}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Nand.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Nand\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Nand</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Nand;
