within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model Average "Validation model for the Average block"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Average avg1
    "Block that output the average of its two inputs"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp1(
    duration=1,
    offset=-2,
    height=6) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Ramp ramp2(
    duration=1,
    offset=1.5,
    height=3.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-26},{-40,-6}})));
equation
  connect(ramp1.y, avg1.u1) annotation (Line(points={{-39,18},{-26,18},{-26,6},{
          -12,6}}, color={0,0,127}));
  connect(ramp2.y, avg1.u2) annotation (Line(points={{-39,-16},{-26,-16},{-26,-6},
          {-12,-6}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/Average.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Average\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Average</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2.0</i> to <i>+6.0</i>, input <code>u2</code> varies from <i>+1.5</i> to <i>+4.5</i>
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Average;
