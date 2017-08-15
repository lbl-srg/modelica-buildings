within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Latch "Validation model for the Latch block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Pulse booPul1(
      width=0.5, period=1.5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,8},{-6,28}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Pulse booPul2(
      width=0.5, period=5) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-26},{-6,-6}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Latch latch1
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(booPul1.y, latch1.u) annotation (Line(points={{-5,18},{10,18},{10,2},
          {25,2}}, color={255,0,255}));
  connect(booPul2.y, latch1.u0) annotation (Line(points={{-5,-16},{10,-16},{10,
           -4},{25,-4}}, color={255,0,255}));
  annotation (
  experiment(StopTime=10.0, Tolerance=1e-06),
   __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Latch.mos"
         "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Latch\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Latch</a>.
</p>
<p>
The <code>latch</code> input <code>u</code> cycles from OFF to ON, with cycle period of <code>1.5 s</code> and <code>50%</code> ON time.
The <code>clr</code> input <code>u0</code> cycles from OFF to ON, with cycle period of <code>5 s</code> and <code>50%</code> ON time.
</p>
</html>", revisions="<html>
<ul>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Latch;
