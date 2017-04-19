within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Toggle "Validation model for the Toggle block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc1(
    cycleOn = true,
    period = 1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,8},{-6,28}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=0.5)
   "Constant as source term"
    annotation (Placement(transformation(extent={{-76,8},{-56,28}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc2(
     cycleOn = true,
     period = 5)
     "Block that outputs cyclic on and off"
     annotation (Placement(transformation(extent={{-26,-26},{-6,-6}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons2(k=0.5)
   "Constant as source term"
     annotation (Placement(transformation(extent={{-76,-26},{-56,-6}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Toggle toggle1
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(cons1.y, dutCyc1.u)
    annotation (Line(points={{-55,18},{-41.5,18},{-28,18}}, color={0,0,127}));
  connect(dutCyc1.y, toggle1.u) annotation (Line(points={{-5,18},{10,18},{10,2},
          {25,2}}, color={255,0,255}));
   connect(dutCyc2.y, toggle1.u0) annotation (Line(points={{-5,-16},{10,-16},{10,
           -4},{25,-4}}, color={255,0,255}));
   connect(cons2.y, dutCyc2.u)
     annotation (Line(points={{-55,-16},{-28,-16}}, color={0,0,127}));
  annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Toggle.mos"
          "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Toggle\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Toggle</a>.
</p>
<p>
The <code>latch</code> input <code>u</code> cycles from OFF to ON, with cycle period of <code>1.5 s</code> and <code>50%</code> ON time.
The <code>clr</code> input <code>u0</code> cycles from OFF to ON, with cycle period of <code>5 s</code> and <code>50%</code> ON time.
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Toggle;
