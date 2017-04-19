within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model And3 "Validation model for the And3 block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc1(
    cycleOn = true,
    period = 1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,26},{-6,46}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=0.5)
   "Constant as source term"
    annotation (Placement(transformation(extent={{-76,26},{-56,46}})));

   Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc2(
     cycleOn = true,
     period = 5)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-26,-8},{-6,12}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons2(k=0.5)
    "Constant as source term"
     annotation (Placement(transformation(extent={{-76,-8},{-56,12}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.And3 and1
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

   Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons3(k=0.5)
    "Constant as source term"
     annotation (Placement(transformation(extent={{-76,-42},{-56,-22}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc3(
     cycleOn = true, period=3)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-26,-42},{-6,-22}})));
equation
  connect(cons1.y, dutCyc1.u)
    annotation (Line(points={{-55,36},{-28,36}},          color={0,0,127}));
  connect(cons2.y, dutCyc2.u)
    annotation (Line(points={{-55,2},{-28,2}},               color={0,0,127}));
  connect(cons3.y,dutCyc3. u)
    annotation (Line(points={{-55,-32},{-28,-32}},           color={0,0,127}));
  connect(dutCyc1.y, and1.u1) annotation (Line(points={{-5,36},{8,36},{8,10},{24,
          10}}, color={255,0,255}));
  connect(dutCyc2.y, and1.u2)
    annotation (Line(points={{-5,2},{10,2},{24,2}}, color={255,0,255}));
  connect(dutCyc3.y, and1.u3) annotation (Line(points={{-5,-32},{8,-32},{8,-6},{
          24,-6}}, color={255,0,255}));
  annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/And3.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.And3\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.And3</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end And3;
