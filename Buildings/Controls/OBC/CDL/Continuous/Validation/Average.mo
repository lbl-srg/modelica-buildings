within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Average "Validation model for the Average block"

  Buildings.Controls.OBC.CDL.Continuous.Average avg1
    "Block that outputs the average of its two inputs"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=6) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=1.5,
    height=3.0) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
equation
  connect(ramp1.y, avg1.u1) annotation (Line(points={{-39,20},{-26,20},{-26,6},
          {-12,6}},color={0,0,127}));
  connect(ramp2.y, avg1.u2) annotation (Line(points={{-39,-20},{-26,-20},{-26,
          -6},{-12,-6}},
                     color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Average.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Average\">
Buildings.Controls.OBC.CDL.Continuous.Average</a>.
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

</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end Average;
