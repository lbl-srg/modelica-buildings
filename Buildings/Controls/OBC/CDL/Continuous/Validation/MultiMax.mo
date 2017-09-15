within Buildings.Controls.OBC.CDL.Continuous.Validation;
model MultiMax "Validation model for the MultiMax block"
extends Modelica.Icons.Example;
  parameter Integer sizOfVec = 5 "Size of the input vector";

  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxVal(nin=sizOfVec)
    "Block that outputs the maximum element of the input vector"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[sizOfVec](k={1,2,3,4,5})
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
equation
  connect(con.y,maxVal. u)
     annotation (Line(points={{-37,0},{-24.5,0},{-12,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/MultiMax.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.MultiMax\">
Buildings.Controls.OBC.CDL.Continuous.MultiMax</a>.
</p>
<p>
The input vector<code>con</code> has size <i>5</i> and its element values are <code>{1,2,3,4,5}</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end MultiMax;
