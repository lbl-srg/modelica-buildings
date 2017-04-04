within Buildings.Experimental.OpenBuildingControl.CDL.Sources.Validation;
model DutyCycle "Validation model for the DutyCycle block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle DutyCyc1(
    CycleOn = true,
    period = 1)
    "Block that output cyclc on and off"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Constant cons(k=30) "Constant as source term"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(cons.y, DutyCyc1.u)
    annotation (Line(points={{-39,0},{-26,0},{-12,0}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Sources/Validation/DutyCycle.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle\">
Buildings.Experimental.OpenBuildingControl.CDL.Sources.DutyCycle</a>.
</p>
<p>
The input <code>k</code> equals to <code>30</code>, which indicates <code>30%</code> of the cycle time the output should be ON.
</p>
</html>", revisions="<html>
<ul>
<li>
March 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DutyCycle;
