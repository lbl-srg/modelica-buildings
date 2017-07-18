within Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Validation;
model Sum "Validation model for the Sum block"
extends Modelica.Icons.Example;
  parameter Integer sizOfVec = 5 "Size of the input vector";

  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sum sum1(nin=sizOfVec)
    "Block that outputs the sum of the elements of the input vector"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant con[sizOfVec](k={1,2,3,4,5})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
equation
  for i in 1:sizOfVec loop
    connect(con[i].y, sum1.u[i])
    annotation (Line(points={{-37,0},{-24.5,0},{-12,0}}, color={0,0,127}));
  end for;
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/CDL/Continuous/Validation/Sum.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sum\">
Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sum</a>.
</p>
<p>
The input vector<code>con</code> has size <i>5</i> and its element values are <code>{1,2,3,4,5}</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Sum;
