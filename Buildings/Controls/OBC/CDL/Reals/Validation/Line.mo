within Buildings.Controls.OBC.CDL.Reals.Validation;
model Line
  "Validation model for the Line block"
  Buildings.Controls.OBC.CDL.Reals.Line line1
    "Block that out the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant x1(
    k=1.0)
    "Block that generate x1"
    annotation (Placement(transformation(extent={{-60,52},{-40,72}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant f1(
    k=0.5)
    "Block that generate f(x1)"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant x2(
    k=2.0)
    "Block that generate x2"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant f2(
    k=1.5)
    "Block that generate f(x2)"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ramp1(
    offset=0,
    duration=0.5,
    startTime=0.25,
    height=3)
    "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Line line2(
    limitAbove=true,
    limitBelow=false)
    "Block that out the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Line line3(
    limitBelow=true,
    limitAbove=false)
    "Block that out the value of the input x along a line specified by two points"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));

equation
  connect(ramp1.y,line1.u)
    annotation (Line(points={{-39,0},{-12,0}},color={0,0,127}));
  connect(f1.y,line1.f1)
    annotation (Line(points={{-39,30},{-24,30},{-24,4},{-12,4}},color={0,0,127}));
  connect(x1.y,line1.x1)
    annotation (Line(points={{-39,62},{-26,62},{-26,8},{-12,8}},color={0,0,127}));
  connect(x2.y,line1.x2)
    annotation (Line(points={{-39,-30},{-24,-30},{-24,-4},{-12,-4}},color={0,0,127}));
  connect(f2.y,line1.f2)
    annotation (Line(points={{-39,-60},{-26,-60},{-26,-8},{-12,-8}},color={0,0,127}));
  connect(ramp1.y,line2.u)
    annotation (Line(points={{-39,0},{-36,0},{-36,-30},{-12,-30}},color={0,0,127}));
  connect(f1.y,line2.f1)
    annotation (Line(points={{-39,30},{-24,30},{-24,-26},{-12,-26}},color={0,0,127}));
  connect(x1.y,line2.x1)
    annotation (Line(points={{-39,62},{-26,62},{-26,-22},{-12,-22}},color={0,0,127}));
  connect(x2.y,line2.x2)
    annotation (Line(points={{-39,-30},{-24,-30},{-24,-34},{-12,-34}},color={0,0,127}));
  connect(f2.y,line2.f2)
    annotation (Line(points={{-39,-60},{-26,-60},{-26,-38},{-12,-38}},color={0,0,127}));
  connect(ramp1.y,line3.u)
    annotation (Line(points={{-39,0},{-36,0},{-36,-60},{-12,-60}},color={0,0,127}));
  connect(f1.y,line3.f1)
    annotation (Line(points={{-39,30},{-24,30},{-24,-56},{-12,-56}},color={0,0,127}));
  connect(x1.y,line3.x1)
    annotation (Line(points={{-39,62},{-26,62},{-26,-52},{-12,-52}},color={0,0,127}));
  connect(x2.y,line3.x2)
    annotation (Line(points={{-39,-30},{-24,-30},{-24,-64},{-12,-64}},color={0,0,127}));
  connect(f2.y,line3.f2)
    annotation (Line(points={{-39,-60},{-26,-60},{-26,-68},{-12,-68}},color={0,0,127}));
  annotation (
    experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/Line.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Line\">
Buildings.Controls.OBC.CDL.Reals.Line</a>.
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
</html>",
      revisions="<html>
<ul>
<li>
March 25, 2018, by Michael Wetter:<br/>
Improved test to validate that the limits are properly used.
</li>
<li>
March 20, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Line;
