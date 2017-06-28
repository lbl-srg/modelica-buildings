within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model Add3 "Validation model for the add3 block"
extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Add3 add1
    "Block that outputs Output the sum of the three inputs"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,22},{-40,42}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp2(
    height=2,
    duration=1,
    offset=-1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Sources.Ramp ramp3(
    height=3,
    duration=1,
    offset=-1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
equation
  connect(ramp1.y, add1.u1) annotation (Line(points={{-39,32},{-26,32},{-26,8},
          {-12,8}},color={0,0,127}));
  connect(ramp2.y, add1.u2) annotation (Line(points={{-39,0},{-26,0},{-12,0}},
                     color={0,0,127}));
  connect(ramp3.y, add1.u3) annotation (Line(points={{-39,-32},{-26,-32},{-26,
          -8},{-12,-8}},
                     color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/Add3.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Add3\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Add3</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>,
input <code>u2</code> varies from <i>-1</i> to <i>+1</i>,
input <code>u3</code> varies from <i>-1</i> to <i>+2</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Add3;
