within Buildings.Controls.OBC.CDL.Continuous.Validation;
model Greater "Validation model for the Greater block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,10},{-6,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-1,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,-32},{-6,-12}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater greater1
    annotation (Placement(transformation(extent={{26,-10},{46,10}})));

equation
  connect(ramp1.y, greater1.u1)
    annotation (Line(points={{-5,20},{8,20},{8,0},{24,0}}, color={0,0,127}));
  connect(ramp2.y, greater1.u2) annotation (Line(points={{-5,-22},{10,-22},{10,
          -8},{24,-8}},
                    color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/Greater.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.Greater\">
Buildings.Controls.OBC.CDL.Continuous.Greater</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 1, 2017, by Jianjun Hu:<br/>
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
end Greater;
