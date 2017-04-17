within Buildings.Experimental.OpenBuildingControl.CDL.Logical.Validation;
model OnDelay "Validation model for the OnDelay block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle dutCyc(
    cycleOn = true,
    period = 1.5)
    "Block that outputs cyclic on and off"
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons1(k=50) "Constant as source term"
    annotation (Placement(transformation(extent={{-76,-10},{-56,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Logical.OnDelay onDelay(
    delayTime = 0.5)
    "Delay a rising edge of the input, but do not delay a falling edge."
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(cons1.y, dutCyc.u)
    annotation (Line(points={{-55,0},{-48,0},{-28,0}},    color={0,0,127}));
  connect(dutCyc.y, onDelay.u)
    annotation (Line(points={{-5,0},{8,0},{24,0}}, color={255,0,255}));
  annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Logical/Validation/OnDelay.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Logical.OnDelay\">
Buildings.Experimental.OpenBuildingControl.CDL.Logical.OnDelay</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 2, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end OnDelay;
