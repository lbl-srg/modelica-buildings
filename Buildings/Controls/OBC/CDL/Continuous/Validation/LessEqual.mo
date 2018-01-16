within Buildings.Controls.OBC.CDL.Continuous.Validation;
model LessEqual "Validation model for the LessEqual block"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp1(
    duration=1,
    offset=-2,
    height=4)  "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,12},{-6,32}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ramp2(
    duration=1,
    offset=-1,
    height=2) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-26,-30},{-6,-10}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu
    annotation (Placement(transformation(extent={{26,-8},{46,12}})));

equation
  connect(ramp1.y, lesEqu.u1)
    annotation (Line(points={{-5,22},{8,22},{8,2},{24,2}}, color={0,0,127}));
  connect(ramp2.y, lesEqu.u2) annotation (Line(points={{-5,-20},{10,-20},{10,-6},
          {24,-6}}, color={0,0,127}));
  annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Continuous/Validation/LessEqual.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Continuous.LessEqual\">
Buildings.Controls.OBC.CDL.Continuous.LessEqual</a>.
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
end LessEqual;
