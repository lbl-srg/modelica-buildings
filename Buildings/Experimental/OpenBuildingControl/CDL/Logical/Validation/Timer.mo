within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model Timer "Validation model for the Timer block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Pulse booPul(
      width=0.5, period=2) "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(booPul.y, timer1.u)
    annotation (Line(points={{-5,0},{10,0},{24,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/Timer.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.Timer\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.Timer</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Timer;
