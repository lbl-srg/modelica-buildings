within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model And "Validation model for the And block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc1(
    cycleOn = true,
    period = 1.5)
    "Block that output cyclic on and off"
    annotation (Placement(transformation(extent={{-26,8},{-6,28}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=50) "Constant as source term"
    annotation (Placement(transformation(extent={{-76,8},{-56,28}})));

   Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc2(
     cycleOn = true,
     period = 5)
     "Block that output cyclic on and off"
     annotation (Placement(transformation(extent={{-26,-26},{-6,-6}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons2(k=50) "Constant as source term"
     annotation (Placement(transformation(extent={{-76,-26},{-56,-6}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And and1
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(cons1.y, dutCyc1.u)
    annotation (Line(points={{-55,18},{-28,18},{-28,18}}, color={0,0,127}));
  connect(cons2.y, dutCyc2.u)
    annotation (Line(points={{-55,-16},{-28,-16},{-28,-16}}, color={0,0,127}));
  connect(dutCyc2.y, and1.u2) annotation (Line(points={{-5,-16},{8,-16},{8,-6},
          {24,-6}}, color={255,0,255}));
  connect(dutCyc1.y, and1.u1) annotation (Line(points={{-5,18},{10,18},{10,2},{
          24,2}}, color={255,0,255}));
  annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/And.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.And\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.And</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end And;
