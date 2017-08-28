within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Line "Validation model for the Line block"
extends Modelica.Icons.Example;

  Buildings.Controls.OBC.CDL.Continuous.Line line1(
    limitBelow = true,
    limitAbove = true)
    "Block that out the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x1(
    k = 1.0) "Block that generate x1"
    annotation (Placement(transformation(extent={{-60,52},{-40,72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f1(
    k = 1.0) "Block that generate f(x1)"
    annotation (Placement(transformation(extent={{-56,20},{-36,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant x2(
    k = 2.0) "Block that generate x2"
    annotation (Placement(transformation(extent={{-56,-42},{-36,-22}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant f2(
    k = 4.0) "Block that generate f(x2)"
    annotation (Placement(transformation(extent={{-60,-76},{-40,-56}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=0,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));

equation
  connect(ramp1.y, line1.u)
    annotation (Line(points={{-51,0},{-12,0}}, color={0,0,127}));
  connect(f1.y, line1.f1) annotation (Line(points={{-35,30},{-24,30},{-24,4},{-12,
          4}}, color={0,0,127}));
  connect(x1.y, line1.x1) annotation (Line(points={{-39,62},{-26,62},{-26,8},{-12,
          8}}, color={0,0,127}));
  connect(x2.y, line1.x2) annotation (Line(points={{-35,-32},{-24,-32},{-24,-4},
          {-12,-4}}, color={0,0,127}));
  connect(f2.y, line1.f2) annotation (Line(points={{-39,-66},{-26,-66},{-26,-8},
          {-12,-8}}, color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Line.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Line\">
Buildings.Controls.OBC.CDL.Continuous.Line</a>.
</p>
<p>
The input <code>u</code> varies from <i>0.0</i> to <i>+2</i>.
</p>
<p>
The block outputs <code>y = a + b u</code>,
where
<code>u</code> is an input
and the coefficients <code>a</code> and <code>b</code>
are determined so that the line intercepts the two input points
specified by the two points <code>x1</code> and <code>f1</code>,
and <code>x2</code> and <code>f2</code>.
</p>
<p>
The parameters <code>limitBelow</code> and <code>limitAbove</code>
determine whether <code>x1</code> and <code>x2</code> are also used
to limit the input <code>u</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>

</html>"));
end Line;
