within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model LogicalSwitch "Validation model for the LogicalSwitch block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc1(
    cycleOn = true,
    period = 1.5)
    "Block that output cyclc on and off"
    annotation (Placement(transformation(extent={{-26,24},{-6,44}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=70) "Constant as source term"
    annotation (Placement(transformation(extent={{-76,24},{-56,44}})));

   Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc2(
     cycleOn = true, period=3)
     "Block that output cyclc on and off: switch between u1 and u3"
     annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons2(k=50) "Constant as source term"
     annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));

   Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc3(
     cycleOn = true, period=5)
     "Block that output cyclc on and off"
     annotation (Placement(transformation(extent={{-26,-46},{-6,-26}})));
   Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons3(k=50) "Constant as source term"
     annotation (Placement(transformation(extent={{-76,-46},{-56,-26}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.LogicalSwitch logicalSwitch
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(cons1.y, dutCyc1.u)
    annotation (Line(points={{-55,34},{-41.5,34},{-28,34}}, color={0,0,127}));
   connect(cons2.y, dutCyc2.u)
     annotation (Line(points={{-55,0},{-28,0}},     color={0,0,127}));
  connect(cons3.y, dutCyc3.u)
    annotation (Line(points={{-55,-36},{-28,-36}}, color={0,0,127}));
  connect(dutCyc2.y, logicalSwitch.u2)
    annotation (Line(points={{-5,0},{10,0},{24,0}}, color={255,0,255}));
  connect(dutCyc1.y, logicalSwitch.u1) annotation (Line(points={{-5,34},{10,34},{10,
          8},{24,8}}, color={255,0,255}));
  connect(dutCyc3.y, logicalSwitch.u3) annotation (Line(points={{-5,-36},{10,-36},
          {10,-8},{24,-8}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/LogicalSwitch.mos"
         "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.LogicalSwitch\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.LogicalSwitch</a>.
</p>
<p>
The input <code>u2</code> is the switch input: If <code>u2 = true</code>, 
then output <code>y = u1</code>;
else output <code>y = u3</code>.
</p>

</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end LogicalSwitch;
