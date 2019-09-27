within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Atan2 "Validation model for the Atan2 block"
  Buildings.Controls.OBC.CDL.Continuous.Atan2 atan2_1
    "Block that outputs atan(u1/u2) of the inputs u1 and u2"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=1,
    height=2)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

equation
  connect(ramp1.y, atan2_1.u1) annotation (Line(points={{-38,20},{-26,20},{-26,
          6},{-12,6}},
                    color={0,0,127}));
  connect(ramp2.y, atan2_1.u2) annotation (Line(points={{-38,-20},{-26,-20},{
          -26,-6},{-12,-6}},
                         color={0,0,127}));
  annotation (
experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Atan2.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Atan2\">
Buildings.Controls.OBC.CDL.Continuous.Atan2</a>.
</p>
<p>
The input <code>u1</code> varies from <i>-2</i> to <i>+2</i>,
The input <code>u2</code> varies from <i>+1</i> to <i>+3</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2017, by Jianjun Hu:<br/>
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
end Atan2;
