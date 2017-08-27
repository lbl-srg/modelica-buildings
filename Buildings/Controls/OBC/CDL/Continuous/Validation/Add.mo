within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Add "Validation model for the add block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Block that outputs the sum of the two inputs"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    height=2,
    duration=1,
    offset=-1) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(ramp1.y, add1.u1) annotation (Line(points={{-39,20},{-26,20},{-26,6},
          {-12,6}},color={0,0,127}));
  connect(ramp2.y, add1.u2) annotation (Line(points={{-39,-20},{-26,-20},{-26,-6},
          {-12,-6}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Add.mos"
        "Simulate and plot"),
    Documentation(
info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Add\">
Buildings.Controls.OBC.CDL.Continuous.Add</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>, input <code>u2</code> varies from <i>-1</i> to <i>+1</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Add;
